require 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answers author
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  it_behaves_like 'Add files', 'answer'
  # scenario 'User adds files when answered the question', js: true do
  #   sign_in user
  #   visit question_path(question)
  #
  #   fill_in 'Содержание', with: 'text text'
  #   3.times do
  #     click_on 'Прикрепить файлы'
  #   end
  #   inputs = all('input[type="file"]')
  #   inputs[0].set("#{Rails.root}/spec/acceptance/questions/create_question_spec.rb")
  #   inputs[1].set("#{Rails.root}/spec/acceptance/questions/destroy_questions_spec.rb")
  #   inputs[2].set("#{Rails.root}/spec/acceptance/questions/edit_question_spec.rb")
  #   inputs[3].set("#{Rails.root}/spec/acceptance/questions/questions_list_spec.rb")
  #
  #   click_on 'Answer the question'
  #   wait_for_ajax
  #   expect(page).to have_css '.answer'
  #   within '.answer' do
  #     expect(page).to have_link 'create_question_spec.rb'
  #     expect(page).to have_link 'destroy_questions_spec.rb'
  #     expect(page).to have_link 'edit_question_spec.rb'
  #     expect(page).to have_link 'questions_list_spec.rb'
  #   end
  # end
end
