require 'acceptance_helper'

feature 'Edit question', %q(
  In order to change question
  As an user
  I want to be able to edit question
) do

  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    scenario 'see the link to edit his question', js: true do
      visit question_path(question)

      within '.question' do
        expect(page).to have_link 'Edit question'
      end
    end
    scenario 'tries to edit his question', js: true do
      visit question_path(question)

      within '.question' do
        click_on 'Edit question'
        fill_in 'Title', with: 'New title'
        fill_in 'Body', with: 'New body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'New title'
        expect(page).to have_content 'New body'
        expect(current_page).to eq question_path(question)

      end
    end
    scenario 'tries to edit someone else question' do

    end

  end
  describe 'Unauthenticated user'
end
