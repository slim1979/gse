require 'acceptance_helper'

feature 'Choose best answer', %q{
  In order to determine the best solution
  As an author of question
  I want to choose the best answer
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:user3) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, user: user, question: question) }
  given!(:answer2) { create(:answer, user: user2, question: question) }
  given!(:answer3) { create(:answer, user: user3, question: question) }

  describe 'Author of question' do

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to best answer', js: true do
      expect(page).to have_link 'Best answer'
    end

    scenario 'choosed the best answer', js: true do
      within '#answer_3' do
        click_on 'Best answer'
      end

      within '.answer:first-child' do
        expect(page).to_not have_content answer1.body
        expect(page).to_not have_content answer2.body
        expect(page).to have_content answer3.body
        expect(page).to have_xpath('//img[@src="/assets/best-272f2f9e50eba3e954cc7a3de060a1d47823677f3589b08e0aa270c327d02782.png"]')
        expect(page).to_not have_link 'Best answer'
      end
      # answers = all('.answer')
      # expect(answers.first).to ....
    end

    scenario 'choosed another best answer', js: true do
      within '#answer_3' do
        click_on 'Best answer'
      end

      within '#answer_2' do
        click_on 'Best answer'
      end

      within '.answer:first-child' do
        expect(page).to_not have_content answer1.body
        expect(page).to_not have_content answer3.body
        expect(page).to have_content answer2.body
        expect(page).to have_xpath('//img[@src="/assets/best-272f2f9e50eba3e954cc7a3de060a1d47823677f3589b08e0aa270c327d02782.png"]')
        expect(page).to_not have_link 'Best answer'
      end

      within "#answer_#{answer3.id}" do
        expect(page).to have_content answer3.body
        expect(page).to have_link 'Best answer'
      end
    end
  end

  scenario 'Unathenticated user does not sees link to best answer', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Best answer'
  end
end
