require 'rails_helper'

feature 'User sign out', %q(
  In order to be able close session
  As an user
  I want to be able to sign out
) do

  given(:user) { create(:user) }

  scenario 'Authenticated user tried to sign out' do

    sign_in(user)
    click_on 'Выйти'

    expect(page).to have_content 'Выход из системы выполнен.'
  end

  scenario 'Unregistered user tried to sign out' do
    visit root_path
    expect(page).to_not have_content 'Выйти'
  end
end
