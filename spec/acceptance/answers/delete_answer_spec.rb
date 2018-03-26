require 'acceptance_helper'

feature 'Delete answer', %q{
  In order to refuse to provide help in solving some problem
  As an author
  I want to delete answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user', js: true do

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to delete answer' do
      expect(page).to have_link 'Удалить'
    end

    scenario 'tries to delete answer' do
      within '.delete_answer' do
        click_on 'Удалить'
      end
      expect(page).to_not have_content answer.body
    end

    scenario 're-render question show template', js: true do
      within '.delete_answer' do
        click_on 'Удалить'
      end

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(current_path).to eq question_path(question)
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to delete someone answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Удалить'
    end
  end
end
