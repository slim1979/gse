require 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an questions author
  I want to be able to attach files
} do

  given(:user) { create(:user) }

  before do
  end

  scenario 'User adds files when asked question', js: true do
    sign_in user
    visit questions_path

    click_on 'Задать вопрос'

    fill_in 'Заголовок', with: 'Question title'
    fill_in 'Содержание', with: 'Question text'

    4.times do
      click_on 'Прикрепить файлы'
    end

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/acceptance/questions/create_question_spec.rb")
    inputs[1].set("#{Rails.root}/spec/acceptance/questions/destroy_questions_spec.rb")
    inputs[2].set("#{Rails.root}/spec/acceptance/questions/edit_question_spec.rb")
    inputs[3].set("#{Rails.root}/spec/acceptance/questions/questions_list_spec.rb")

    click_on 'Создать'

    click_on 'Question title'

    expect(page).to have_link 'create_question_spec.rb', href: '/uploads/attach/file/1/create_question_spec.rb'
    expect(page).to have_link 'destroy_questions_spec.rb', href: '/uploads/attach/file/2/destroy_questions_spec.rb'
    expect(page).to have_link 'edit_question_spec.rb', href: '/uploads/attach/file/3/edit_question_spec.rb'
    expect(page).to have_link 'questions_list_spec.rb', href: '/uploads/attach/file/4/questions_list_spec.rb'
  end
end
