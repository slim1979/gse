require 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of Answer
  I qant to be able to edit answer
} do

  given(:user)      { create(:user) }
  given(:user2)     { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question2) { create(:question, user: user2) }
  given!(:answer)   { create(:answer, user: user, question: question) }
  given!(:answer2)  { create(:answer, user: user2, question: question2) }

  scenario 'Unauthenticated user tried to edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'edit answer'
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'see link to edit his answer' do
      within '.edit_answer' do
        expect(page).to have_link 'Редактировать'
      end
    end

    scenario 'tried to edit his answer', js: true do
      within '.answer' do
        click_on 'Редактировать'
        fill_in 'Содержание', with: 'some new answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'some new answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tried to edit someone else answer' do
      visit question_path(question2)

      expect(page).to_not have_link 'Редактировать'
    end
  end
end
