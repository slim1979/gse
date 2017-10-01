require 'acceptance_helper'

feature 'Edit question', %q(
  In order to change question
  As an user
  I want to be able to edit question
) do

  given(:user)      { create(:user) }
  given(:user2)      { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question2) { create(:question, user: user2) }

  describe 'Authenticated user' do

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'see the link to edit his question', js: true do
      expect(page).to have_link 'Edit question'
    end

    scenario 'tries to edit his question', js: true do

      click_on 'Edit question'

      within '.edit_question_form' do
        fill_in 'Title', with: 'New title'
        fill_in 'Body', with: 'New body'
        click_on 'Save'
      end

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'New title'
      expect(page).to have_content 'New body'
      expect(current_path).to eq question_path(question)
    end

    scenario 'tries to edit someone else question', js: true do
      visit question_path(question2)

      expect(page).to_not have_link 'Edit question'
    end

  end
  describe 'Unauthenticated user' do
    scenario 'tries to edit question' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end
