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
      expect(page).to have_link 'Выбрать лучшим'
    end

    scenario 'choosed the best answer', js: true do
      within ".answer_#{answer3.id}>.advanced_staff" do
        click_on 'Выбрать лучшим'
      end
      within '.answer:first-child' do
        expect(page).to_not have_content answer1.body
        expect(page).to_not have_content answer2.body
        expect(page).to have_content answer3.body
        expect(page).to have_css '.img'
        expect(page).to_not have_link 'Выбрать лучшим'
      end
      # answers = all('.answer')
      # expect(answers.first).to ....
    end

    scenario 'choosed another best answer', js: true do
      within ".answer_#{answer3.id}>.advanced_staff" do
        click_on 'Выбрать лучшим'
      end

      within ".answer_#{answer2.id}>.advanced_staff" do
        click_on 'Выбрать лучшим'
      end

      within '.answer:first-child' do
        expect(page).to_not have_content answer1.body
        expect(page).to_not have_content answer3.body
        expect(page).to have_content answer2.body
        expect(page).to have_css '.img'
        expect(page).to_not have_link 'Выбрать лучшим'
      end

      within ".body_of_#{answer3.id}" do
        expect(page).to have_content answer3.body
      end

      within ".answer_#{answer3.id}>.advanced_staff" do
        expect(page).to have_link 'Выбрать лучшим'
      end
    end
  end

  scenario 'Other question author tries to choose best answer', js: true do
    sign_in user2
    visit question_path(question)
    expect(page).to_not have_link 'Выбрать лучшим'
  end

  scenario 'Unathenticated user does not sees link to best answer', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Выбрать лучшим'
  end
end
