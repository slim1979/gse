require 'acceptance_helper'

feature 'Votes for answer', %q{
  In order to show my attitude to an answer
  As an user
  I want to be able to vote for answer
} do

  given(:author_of_question)  { create(:user) }
  given(:author_of_answer)    { create(:user) }
  given(:some_other_user)     { create(:user) }
  given(:some_other_user2)    { create(:user) }
  given(:some_other_user3)    { create(:user) }
  given(:question)            { create(:question, user: author_of_question) }
  given!(:answer)             { create(:answer, user: author_of_answer, question: question) }

  describe 'Authenticated user' do
    before do
      sign_in author_of_question
      visit question_path(question)
      @current_answer_votes_count = answer.votes_count
    end

    scenario 'see the \'vote for answer\' buttons' do
      expect(page).to have_link 'like'
      expect(page).to have_link 'dislike'
    end

    scenario 'vote for the answer - like - for the first time', js: true do
      click_on 'like'
      within ".answer_votes_count_#{answer.id}" do
        expect(page).to have_content @current_answer_votes_count + 1
      end
    end

    scenario 'vote for the answer - dislike - for the first time', js: true do
      click_on 'dislike'
      within ".answer_votes_count_#{answer.id}" do
        expect(page).to have_content @current_answer_votes_count - 1
      end
    end

    scenario 'vote for the answer - like - the second and subsequent times, by same user will not increase the answer rating', js: true do
      3.times { click_on 'like' }
      within ".answer_votes_count_#{answer.id}" do
        expect(page).to have_content 1
      end
    end

    scenario 'vote for the answer - dislike - the second and subsequent times will not decrease the answer rating', js: true do
      3.times { click_on 'dislike' }
      within ".answer_votes_count_#{answer.id}" do
        expect(page).to have_content(-1)
      end
    end
  end


  describe 'Unauthenticated user' do
    scenario 'tries to vote for answer' do
      visit question_path(question)

      expect(page).to_not have_link 'like'
      expect(page).to_not have_link 'dislike'
    end
  end
end
