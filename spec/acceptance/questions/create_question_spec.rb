require 'acceptance_helper'

feature 'Create question', %q(
  In order to get answer from community
  As an authenticated user
  I want to be able to ask the question
) do

  given(:user) { create(:user) }

  scenario 'Authenticated user created the question', js: true do

    sign_in(user)

    visit questions_path
    click_on 'Задать вопрос'
    fill_in 'Заголовок', with: 'Test question'
    fill_in 'Содержание', with: 'text text'

    click_on 'Создать'
    expect(page).to have_content 'Test question'
  end

  context 'multiple sessions', js: true do
    scenario "question appears to another user's page" do
      Capybara.using_session('user') do
        sign_in user
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Задать вопрос'
        within 'form' do
          fill_in 'Заголовок', with: 'Test question'
          fill_in 'Содержание', with: 'text text'
        end

        click_on 'Создать'
        wait_for_ajax

        expect(page).to have_content 'Test question'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end

  scenario 'Authenticated user created invalid question', js: true do

    sign_in(user)

    visit questions_path
    click_on 'Задать вопрос'
    fill_in 'Заголовок', with: nil
    fill_in 'Содержание', with: nil
    click_on 'Создать'

    expect(page).to have_content 'При заполнении формы возникли ошибки:'
    expect(page).to have_content 'Заголовок не может быть пустым'
    expect(page).to have_content 'Содержание не может быть пустым'
  end

  scenario 'Unauthenticated user created the question', js: true do

    visit questions_path
    click_on 'Задать вопрос'
    within 'form' do
      fill_in 'Заголовок', with: 'Test question'
      fill_in 'Содержание', with: 'text text'
    end
    click_on 'Создать'

    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться'
  end
end
