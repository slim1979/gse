require 'acceptance_helper'

feature 'Delete answer', '
  In order to refuse to provide help in solving some problem
  As an author
  I want to delete answer
' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user' do

    before do
      sign_in user
      visit question_path(question)
    end
    scenario 'sees link to delete answer', js: true do

      expect(page).to have_link 'Delete answer'
    end
    scenario 'tries to delete answer', js: true do
      click_on 'Delete answer'

      expect(page).to_not have_content answer.body
    end
    scenario 're-render question show template', js: true do
      click_on 'Delete answer'

      expect(current_path).to eq question_path(question)
    end
  end
end
