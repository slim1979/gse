require 'rails_helper'

feature 'Browse through the questions and its answers', %q(
  In order to solve own problem
  As an user
  I want to be able to see available issues and its solve
) do

  casting

  scenario 'Authenticated user can browse the question and its answers' do
    sign_in(user)
    visit questions_path

    click_on 'show question'

    expectations
  end

  scenario 'Unauthenticated user can browse the question and its answers' do

    visit questions_path

    click_on 'show question'
    expectations
  end
end
