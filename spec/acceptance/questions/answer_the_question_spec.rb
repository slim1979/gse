require 'acceptance_helper'

feature 'Answer the question', %q(
  In order to solve someone problem
  As an authenticated user
  I want to be able to answer the question
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user can answer the question', js: true do

    sign_in(user)
    question

    visit questions_path
    click_on 'show question'
    fill_in 'Содержание', with: 'Some text to solve problem'
    first('.answer-the-question').click
    expect(page).to have_content 'Some text to solve problem'
  end

  scenario 'Authenticated user created invalid answer', js: true do

    sign_in(user)
    question

    visit questions_path
    click_on 'show question'
    fill_in 'Содержание', with: nil
    first('.answer-the-question').click
    expect(page).to have_content 'При заполнении формы возникли ошибки:'
    expect(page).to have_content 'Содержание не может быть пустым'
  end

  scenario 'Unauthenticated user can\'t answer the question' do

    question
    visit questions_path
    click_on 'show question'

    expect(page).to_not have_css '.new_answer'
    expect(page).to_not have_content 'Ответить на вопрос'
  end
end
