require 'acceptance_helper'

feature 'Create question', %q(
  In order to get answer from community
  As an authenticated user
  I want to be able to ask the question
) do

  given(:user) { create(:user) }

  it_behaves_like 'Acceptance create object', 'question'

  def load_params
    @shared_params = { path: questions_path }
  end
end
