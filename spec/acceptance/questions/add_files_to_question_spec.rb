require 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an questions author
  I want to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User adds files when asked question' do
    fill_in 'Заголовок', with: 'Test question'
    fill_in 'Содержание', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/acceptance/questions/create_question_spec.rb"

    click_on 'Create'
    expect(page).to have_content 'create_question_spec.rb'
  end
end
