require 'acceptance_helper'

feature 'Authentication with Twitter', %q{
  In order to authenticate on site
  as an social network user
  I want to be able to login with my social account
} do

  describe 'User doesn\'t have any account on this site yet' do

    scenario 'and user can see link to login with socials' do
      visit new_user_session_path
      expect(page).to have_content 'Sign in with Twitter'
    end

    scenario 'and click on link will make it possible to login to the site' do
      visit new_user_session_path

      click_on 'Sign in with Twitter'
      fill_in :email_address, with: 'some@email.com'
      click_on 'Create Email'
      open_email('some@email.com')
      current_email.click_link 'Подтверждаю'
      expect(current_path).to eq new_user_session_path
      click_on 'Sign in with Twitter'
      expect(page).to have_content 'twitter'
    end
  end
end
