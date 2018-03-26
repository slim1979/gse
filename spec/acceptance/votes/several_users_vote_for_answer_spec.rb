require 'acceptance_helper'

feature 'Several users votes for the answer', %q{
  In order to understand the opinion of the community
  As an answer author
  I want to be able to collect a few votes from users
} do

  given(:author_of_question)  { create(:user) }
  given(:author_of_answer)    { create(:user) }
  given(:some_other_user)     { create(:user) }
  given(:some_other_user2)    { create(:user) }
  given(:some_other_user3)    { create(:user) }
  given(:question)            { create(:question, user: author_of_question) }
  given!(:answer)             { create(:answer, user: author_of_answer, question: question) }

  describe 'The multi-user voting pressuresa in the ranking of answer', js: true do
    it_behaves_like 'Muliusers votes for', 'answer'

    def load_params
      @shared_params = { object: answer }
    end
  end
end
