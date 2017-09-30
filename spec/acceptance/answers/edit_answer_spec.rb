require 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of Answer
  I qant to be able to edit answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Unauthenticated user tried to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'edit answer'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'see link to edit his answer' do
      within '.edit' do
        expect(page).to have_link 'Edit answer'
      end
    end

    scenario 'tried to edit his answer', js: true do
      within '.answer' do
        click_on 'Edit answer'
        fill_in 'Answer', with: 'some new answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'some new answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tried to edit someone else answer'
  end
end
