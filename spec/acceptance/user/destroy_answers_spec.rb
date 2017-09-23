require 'rails_helper'

feature 'Destroy answer', %q(
  In order to be able to refuse to answer
  As an author
  I want to be able to delete own answer
) do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  before do
    question
    answer
  end

  scenario 'Authenticated user tries to delete his own answer' do

    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
    expect(page).to have_content 'Your answer successfully deleted!'
  end

  scenario 'Authenticated user tries to delete someone else\'s answer' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Unauthenticated user tries to delete someone else\'s answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
