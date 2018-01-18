require 'acceptance_helper'

feature 'Answer the question', %q(
  In order to solve someone problem
  As an authenticated user
  I want to be able to answer the question
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can answer the question', js: true do
      within '.new_answer' do
        fill_in 'Содержание', with: 'Some text to solve problem'
        click_on 'Answer the question'
      end
      expect(page).to have_content 'Some text to solve problem'
    end

    scenario 'created invalid answer', js: true do
      within '.new_answer' do
        fill_in 'Содержание', with: nil
        click_on 'Answer the question'
      end
      wait_for_ajax
      within '.new_answer' do
        error_alert = find('textarea[placeholder="Введите текст ответа"]')
        expect(error_alert).to_not eq nil
      end
    end
  end

  context 'multiple sessions', js: true do
    scenario "answer appears to another user's page" do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new_answer' do
          fill_in 'Содержание', with: 'Some text to solve problem'
          click_on 'Answer the question'
        end
        expect(page).to have_content 'Some text to solve problem'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Some text to solve problem'
      end
    end
  end

  scenario 'Unauthenticated user can\'t answer the question', js: true do
    visit questions_path
    click_on question.title

    expect(page).to_not have_css '.new_answer'
    expect(page).to_not have_content 'Answer the question'
  end
end
