require 'acceptance_helper'

feature 'Destroy question', %q(
  In order to close issue
  As an author
  I want to be able to delete own question
) do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:own_question) { create(:question, user: user) }
  given(:other_author_question) { create(:question, user: user2) }

  scenario 'Authenticated user tries to delete his own question' do

    sign_in(user)
    own_question
    visit root_path
    click_on 'delete question'


    expect(page).to_not have_content own_question.title
    expect(page).to_not have_content own_question.body
    expect(page).to have_content 'Your question successfully deleted!'
  end

  scenario 'Authenticated user tries to delete to remove someone else\'s question' do
    sign_in(user)
    other_author_question
    visit questions_path

    expect(page).to_not have_content 'delete question'
  end

  scenario 'Unauthenticated user created the question' do
    other_author_question
    visit questions_path

    expect(page).to_not have_content 'delete question'
  end
end
