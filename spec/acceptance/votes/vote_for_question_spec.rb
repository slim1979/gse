require 'acceptance_helper'

feature 'Votes for question', %q{
  In order to show my attitude to an question
  As an user
  I want to be able to vote for question
} do

  given(:author_of_question)  { create(:user) }
  given(:some_other_user)     { create(:user) }
  given!(:question)           { create(:question, user: author_of_question) }

  describe 'Authenticated user' do
    let(:like) { find('a.like').click }
    let(:dislike) { find('a.dislike').click }
    context 'author of question does not can vote for question' do
      scenario 'do not see the \'vote for question\' buttons' do
        sign_in author_of_question
        visit question_path(question)

        within '.question' do
          expect(page).to_not have_css '.like'
          expect(page).to_not have_css '.dislike'
        end
      end
    end

    context 'other users can vote for question' do
      before do
        sign_in some_other_user
        visit question_path(question)
        @current_question_votes_count = question.votes_count
      end

      scenario 'vote for the question - like - for the first time', js: true do
        within '.question' do
          like
          within ".question_votes_count_#{question.id}" do
            expect(page).to have_content @current_question_votes_count + 1
          end
        end
      end

      scenario 'vote for the question - dislike - for the first time', js: true do
        within '.question' do
          dislike
          within ".question_votes_count_#{question.id}" do
            expect(page).to have_content @current_question_votes_count - 1
          end
        end
      end

      scenario 'vote for the question - like - the second and subsequent times, by same user will not increase the answer rating', js: true do
        within '.question' do
          3.times { like }
          within ".question_votes_count_#{question.id}" do
            expect(page).to have_content 1
          end
        end
      end

      scenario 'vote for the question - dislike - the second and subsequent times will not decrease the answer rating', js: true do
        within '.question' do
          3.times { dislike }
          within ".question_votes_count_#{question.id}" do
            expect(page).to have_content(-1)
          end
        end
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
