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
    let(:like) { find('a.like').click }
    let(:dislike) { find('a.dislike').click }

    before do
      sign_in author_of_question
      visit question_path(question)
      @votes_count = answer.votes_count
    end

    scenario 'see the \'vote for answer\' buttons' do
      expect(page).to have_selector '.like'
      expect(page).to have_selector '.dislike'
    end

    it_behaves_like 'Vote for', 'answer'

    def load_params
      @shared_params = { object: answer }
    end
  end


  describe 'Unauthenticated user' do
    it_behaves_like 'Cannot vote for', 'answer'
  end
end
