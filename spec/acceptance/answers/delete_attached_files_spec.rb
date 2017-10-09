require 'acceptance_helper'

feature 'Destroy answers attaches', %q(
  In order to reduce attaches count
  As an author
  I want to be able to delete answers attaches
) do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:answer_attach) { create(:attach, attachable: answer) }

  scenario 'Author of the answer tries to delete answer attaches', js: true do

    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
    expect(page).to have_content answer_attach.file.filename

    within '.delete_answer_attach' do
      click_on 'delete'
    end

    expect(page).to_not have_content answer_attach.file.filename
  end

  scenario 'Someone else tries to delete answer attaches', js: true do

    sign_in(user2)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
    expect(page).to have_content answer_attach.file.filename

    within "#file_#{answer_attach.id}" do
      expect(page).to_not have_link 'delete'
    end
  end

  scenario 'Unauthenticated user tries to delete answer attaches', js: true do

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
    expect(page).to have_content answer_attach.file.filename

    within "#file_#{answer_attach.id}" do
      expect(page).to_not have_link 'delete'
    end
  end
end
