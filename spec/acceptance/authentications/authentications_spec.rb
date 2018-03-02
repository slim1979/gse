require 'acceptance_helper'

feature 'Authentication with socials', %q{
  In order to authenticate on site
  as an social network user
  I want to be able to login with my social account
} do

  given(:user) { create(:user) }
  given(:auth) { create(:authorization, user: user, email: user.email) }

  %w[Facebook Twitter].each do |network|
    describe "#{network}. User doesn\'t have any accounts on this site yet" do

      scenario "and user can see link to login with #{network}" do
        visit new_user_session_path
        expect(page).to have_content "Sign in with #{network}"
      end

      context "one click on link will make it possible to login to the site with #{network}" do
        scenario "#{network} doesn\'t return user email" do
          visit new_user_session_path

          click_on "Sign in with #{network}"
          fill_in :address, with: 'some@email.com'
          click_on 'Create Email'
          open_email('some@email.com')
          current_email.click_link 'Подтверждаю'
          expect(current_path).to eq root_path
          auth = Authorization.last
          expect(page).to have_content "Вход осуществлен с помощью #{auth.provider.capitalize}"
        end

        scenario "#{network} return user email" do
          visit new_user_session_path
          OmniAuth.config.mock_auth[:default]['info']['email'] = user.email
          click_on "Sign in with #{network}"
          OmniAuth.config.mock_auth[:default]['info'].delete('email')
        end
      end
    end

    describe 'User already have account on site' do
      scenario "user tries to login on site with exist account via #{network}" do
        auth
        visit new_user_session_path
        click_on "Sign in with #{network}"
        expect(page).to have_content "Вход в систему выполнен с учётной записью из #{auth.provider.capitalize}"
      end
    end
  end
end
