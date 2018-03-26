require 'acceptance_helper'

feature 'User can cancel his choise', %q{
  In order to change my vote
  As an user
  I want to be able to cancel my choise
} do

  given(:author_of_question) { create(:user) }
  given(:author_of_answer)   { create(:user) }
  given(:other_user)         { create(:user) }
  given!(:question)          { create(:question, user: author_of_question) }
  given!(:answer)            { create(:answer, user: author_of_answer, question: question) }

  describe 'Authenticated user' do
    it_behaves_like 'Can cancel vote for', 'answer'

    def load_params
      @shared_params = { object: answer }
    end
  end
end
