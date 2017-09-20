require 'rails_helper'

feature 'Answer the question', %q(
  In order to solve someone problem
  As an authenticated user
  I want to be able to answer the question
) do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user created the question' do

    sign_in(user)
    question

    visit questions_path
    click_on 'Show question'

    click_on 'Answer the question'
    fill_in 'Body', with: 'Some text to solve problem'
    click_on 'Answer'

    expect(page).to have_content 'Some text to solve problem'  
  end

  scenario 'Authenticated user created the question' do

    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
