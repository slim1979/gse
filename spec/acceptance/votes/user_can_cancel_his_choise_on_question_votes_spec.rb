require 'acceptance_helper'

feature 'User can cancel his choise, when votes for question', %q{
  In order to change my vote
  As an user
  I want to be able to cancel my choise
} do

  given(:author_of_question)  { create(:user) }
  given(:other_user)          { create(:user) }
  given!(:question)           { create(:question, user: author_of_question) }

  describe 'Authenticated user' do
    it_behaves_like 'Can cancel vote for', 'question'

    def load_params
      @shared_params = { object: question }
    end
  end
end
