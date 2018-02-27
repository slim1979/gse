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

  scenario 'The multi-user voting pressuresa in the ranking of question', js: true do
    sign_in some_other_user
    visit question_path(question)
    within ".question" do
      click_on 'like'
    end
    sign_out

    sign_in some_other_user2
    visit question_path(question)
    within ".question" do
      click_on 'like'
    end
    sign_out

    sign_in some_other_user3
    visit question_path(question)
    within ".question" do
      click_on 'dislike'
    end
    sign_out

    visit question_path(question)

    within ".question_votes_count_#{question.id}" do
      expect(page).to have_content 1
    end
  end
end
