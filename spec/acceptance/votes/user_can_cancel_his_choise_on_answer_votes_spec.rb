require 'acceptance_helper'

feature 'User can cancel his choise', %q{
  In order to change my vote
  As an user
  I want to be able to cancel my choise
} do

  given(:author_of_question)  { create(:user) }
  given(:author_of_answer)    { create(:user) }
  given!(:question)            { create(:question, user: author_of_question) }
  given!(:answer)             { create(:answer, user: author_of_answer, question: question) }

  describe 'Authenticated user' do
    before do
      sign_in author_of_question
      visit question_path(question)
    end

    scenario 'vote for the answer - canceled his choise', js: true do
      current_answer_votes_count = answer.votes_count
      expect(current_answer_votes_count).to eq 0

      within '.answer' do
        click_on 'like'
      end

      within ".answer_votes_count_#{answer.id}" do
        expect(page).to have_content current_answer_votes_count + 1
        answer.reload
        expect(answer.votes_count).to eq 1
      end

      within '.answer' do
        click_on 'dislike'
      end

      within ".answer_votes_count_#{answer.id}" do
        expect(page).to have_content current_answer_votes_count
      end

      within '.answer' do
        click_on 'dislike'
      end

      within ".answer_votes_count_#{answer.id}" do
        expect(page).to have_content current_answer_votes_count - 1
      end

      within '.answer' do
        click_on 'like'
      end

      within ".answer_votes_count_#{answer.id}" do
        expect(page).to have_content current_answer_votes_count
      end
    end
  end
end
