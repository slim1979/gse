require 'rails_helper'

feature 'The user register itself on the website', %q(
  In order to be able to ask questions and solve problem
  As an user
  I want to be able to sign up
) do

  given(:user) { create(:user) }

  scenario 'User tried to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'new_one@test.com'
    fill_in 'Password', with: 'qwerty'
    fill_in 'Password confirmation', with: 'qwerty'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end
end
