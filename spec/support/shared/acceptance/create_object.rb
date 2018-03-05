def create_question(content)
  click_on 'Задать вопрос'
  fill_in 'Заголовок', with: content == 'valid' ? 'Test question' : nil
  fill_in 'Содержание', with: content == 'valid' ? 'Text text' : nil

  click_on 'Создать'
  wait_for_ajax
end

def create_answer(content)
  fill_in 'Содержание', with: content == 'valid' ? 'Text text' : nil
  click_on 'Answer the question'
  wait_for_ajax
end

def expectation(params)
  expect(page).to have_content 'Test question' if params == 'question'
  expect(page).to have_content 'Text text' unless params == 'question'
end

RSpec.shared_examples 'Acceptance create object' do |params|
  before { load_params }

  describe 'Authenticated user' do

    before do
      sign_in(user)
      visit @shared_params[:path]
    end

    scenario "can #{params == 'question' ? 'create' : 'answer'} the question", js: true do
      send("create_#{params}", 'valid')
      expect(page).to have_content(params == 'question' ? 'Test question' : 'Text text')
    end

    scenario "can\'t create invalid #{params == 'question' ? 'question' : 'answer'}", js: true do
      send("create_#{params}", 'invalid')
      if params == 'question'
        expect(page).to have_content %(При заполнении формы возникли ошибки: Заголовок не может быть пустым Содержание не может быть пустым)
      else
        error_alert = find('textarea[placeholder="Введите текст ответа"]')
        expect(error_alert).to_not eq nil
      end
    end
  end

  context 'multiple sessions', js: true do
    scenario "#{params} appears to another user's page" do
      Capybara.using_session('user') do
        sign_in user
        visit @shared_params[:path]
      end

      Capybara.using_session('guest') do
        visit @shared_params[:path]
      end

      Capybara.using_session('user') do
        send("create_#{params}", 'valid')
        expectation(params)
      end

      Capybara.using_session('guest') do
        expectation(params)
      end
    end
  end

  scenario 'Unauthenticated user can\'t answer the question', js: true do
    visit questions_path
    if params == 'question'
      expect(page).to_not have_content 'Задать вопрос'
    else
      click_on question.title

      expect(page).to_not have_css '.new_answer'
      expect(page).to_not have_content 'Answer the question'
    end
  end
end
