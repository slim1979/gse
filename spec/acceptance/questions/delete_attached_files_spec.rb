require 'acceptance_helper'

feature 'Destroy questions attaches', %q(
  In order to reduce attaches count
  As an author
  I want to be able to delete questions attaches
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:question_attach) { create(:attach, attachable: question) }

  scenario 'Author of the question tries to delete question attaches', js: true do

    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content question_attach.file.filename

    within '.delete_question_attach' do
      click_on 'delete'
    end

    expect(page).to_not have_content question_attach.file.filename
  end
end
