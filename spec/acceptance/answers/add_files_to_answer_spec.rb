require 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answers author
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'User adds files when asked question', js: true do
    fill_in 'Содержание', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/acceptance/questions/create_question_spec.rb"

    click_on 'Answer the question'
    within '.answer' do
      expect(page).to have_link 'create_question_spec.rb', href: '/uploads/attach/file/1/create_question_spec.rb'
    end
  end
end
