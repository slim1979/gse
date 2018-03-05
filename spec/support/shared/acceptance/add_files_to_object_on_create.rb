RSpec.shared_examples 'Add files' do |params|
  scenario "User adds files when #{params == 'question' ? 'asked' : 'answered the'} question", js: true do
    sign_in user

    if params == 'question'
      visit questions_path
      click_on 'Задать вопрос'
      fill_in 'Заголовок', with: 'Question title'
    else
      visit question_path(question)
    end

    fill_in 'Содержание', with: 'text text'

    click_on 'Прикрепить файлы'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/acceptance/questions/create_question_spec.rb")
    inputs[1].set("#{Rails.root}/spec/acceptance/questions/destroy_questions_spec.rb")

    if params == 'question'
      click_on 'Создать'
      click_on 'Question title'
    else
      click_on 'Answer the question'
      expect(page).to have_css '.answer'
    end

    within ".#{params}" do
      expect(page).to have_link 'create_question_spec.rb'
      expect(page).to have_link 'destroy_questions_spec.rb'
    end
  end
end
