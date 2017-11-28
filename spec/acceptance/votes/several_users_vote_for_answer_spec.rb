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

  scenario 'The multi-user voting pressuresa in the ranking of answer', js: true do
    sign_in author_of_question
    visit question_path(question)
    within "#answer_#{answer.id}" do
      click_on 'like'
    end
    sign_out

    sign_in some_other_user
    visit question_path(question)
    within "#answer_#{answer.id}" do
      click_on 'like'
    end
    sign_out

    sign_in some_other_user2
    visit question_path(question)
    within "#answer_#{answer.id}" do
      click_on 'like'
    end
    sign_out

    sign_in some_other_user3
    visit question_path(question)
    within "#answer_#{answer.id}" do
      click_on 'dislike'
    end
    sign_out

    visit question_path(question)

    within ".answer_votes_count_#{answer.id}" do
      expect(page).to have_content 2
    end
  end
end
