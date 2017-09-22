require 'rails_helper'

feature 'Create question', %q(
  In order to get answer from community
  As an authenticated user
  I want to be able to ask the question
) do

  given(:user) { create(:user) }

  scenario 'Authenticated user created the question' do

    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Заголовок', with: 'Test question'
    fill_in 'Содержание', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'Your question created successfully!'
  end

  scenario 'Unauthenticated user created the question' do

    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться'
  end
end
