require 'acceptance_helper'

feature 'User can cancel his choise, when votes for question', %q{
  In order to change my vote
  As an user
  I want to be able to cancel my choise
} do

  given(:author_of_question)  { create(:user) }
  given!(:question)           { create(:question, user: author_of_question) }

  describe 'Authenticated user' do
    before do
      sign_in author_of_question
      visit question_path(question)
    end

    scenario 'vote for the question - canceled his choise', js: true do
      current_question_votes_count = question.votes_count
      expect(current_question_votes_count).to eq 0

      click_on 'like'
      within ".question_votes_count_#{question.id}" do
        expect(page).to have_content current_question_votes_count + 1
        question.reload
        expect(question.votes_count).to eq 1
      end

      click_on 'dislike'
      within ".question_votes_count_#{question.id}" do
        expect(page).to have_content current_question_votes_count
      end

      click_on 'dislike'
      within ".question_votes_count_#{question.id}" do
        expect(page).to have_content current_question_votes_count - 1
      end

      click_on 'like'
      within ".question_votes_count_#{question.id}" do
        expect(page).to have_content current_question_votes_count
      end
    end
  end
end
