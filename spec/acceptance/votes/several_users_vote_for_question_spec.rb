require 'acceptance_helper'

feature 'Several users votes for the question', %q{
  In order to understand the opinion of the community
  As an question author
  I want to be able to collect a few votes from users
} do

  given(:author_of_question)  { create(:user) }
  given(:some_other_user)     { create(:user) }
  given(:some_other_user2)    { create(:user) }
  given(:some_other_user3)    { create(:user) }
  given(:question)            { create(:question, user: author_of_question) }

  describe 'The multi-user voting pressuresa in the ranking of question', js: true do
    it_behaves_like 'Muliusers votes for', 'question'

    def load_params
      @shared_params = { object: question }
    end
  end
end
