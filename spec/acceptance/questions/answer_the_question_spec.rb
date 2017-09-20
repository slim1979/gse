require 'rails_helper'

feature 'Answer the question', %q(
  In order to solve someone problem
  As an authenticated user
  I want to be able to answer the question
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user can answer the question' do

    sign_in(user)
    question

    visit questions_path
    click_on 'show question'
    fill_in 'Body', with: 'Some text to solve problem'
    click_on 'Answer the question'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content 'Some text to solve problem'
  end

  scenario 'Unauthenticated user can\'t answer the question' do

    question
    visit questions_path
    click_on 'show question'

    click_on 'Answer the question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
