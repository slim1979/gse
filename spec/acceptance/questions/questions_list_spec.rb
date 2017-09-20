require 'rails_helper'

feature 'To see a list of issues', %q(
  In order to find the same problem
  As an diffrent user role
  I want to be able to see the list of questions
) do

  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 5, user: user) }

  scenario 'Authenticated user see the list of questions' do

    sign_in(user)
    reaching_the_questions_list
  end

  scenario 'Authenticated user created the question' do

    reaching_the_questions_list
  end
end
