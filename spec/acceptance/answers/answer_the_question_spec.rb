require 'acceptance_helper'

feature 'Answer the question', %q(
  In order to solve someone problem
  As an authenticated user
  I want to be able to answer the question
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  it_behaves_like 'Acceptance create object', 'answer'

  def load_params
    @shared_params = { path: question_path(question) }
  end
end
