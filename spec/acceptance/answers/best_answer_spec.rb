require 'acceptance_helper'

feature 'Choose best answer', %q{
  In order to determine the best solution
  As an author of question
  I want to choose the best answer
} do


  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, user: user2, question: question) }

  scenario 'Authenticated author of question', js: true do
    sign_in user
    visit question_path(question)
    expect(page).to have_button 'Best answer'
  end
end
