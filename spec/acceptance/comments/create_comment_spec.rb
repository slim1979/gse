require 'acceptance_helper'

feature 'Comment some content', %q(
  In order to comment some content
  As an authenticated user
  I want to be able to leave a comment
) do

  given(:author_of_question) { create(:user) }
  given(:author_of_answer)   { create(:user) }
  given!(:question)          { create(:question, user: author_of_question) }
  given!(:answer)            { create(:answer, question: question, user: author_of_answer) }

  describe 'Authorized user leaves a comment to', js: true do
    context 'question:' do
      scenario 'user sees link to leave a comment' do
        sign_in author_of_question
        visit question_path(question)
        within '.question' do
          expect(page).to have_link 'Комментировать'
        end
      end

      scenario 'user leaves a comment' do
        sign_in author_of_question
        visit question_path(question)

        within '.question' do
          click_on 'Комментировать'
        end
        # form for new comment is raising
        expect(page).to have_css 'form.new_comment'
        # creating comment
        fill_in 'Body', with: 'New comment'
        click_on 'Create Comment'
        # form is hiding
        expect(page).to_not have_css 'form.new_comment'
        # new comment is now showed in .question>.comments
        within '.question>.comments' do
          expect(page).to have_content 'New comment'
        end
      end
    end
    context 'answer:' do
      scenario 'user sees link to leave a comment' do
        sign_in author_of_question
        visit question_path(question)
        within '.answer' do
          expect(page).to have_link 'Комментировать'
        end
      end

      scenario 'user leaves a comment' do
        sign_in author_of_question
        visit question_path(question)

        within '.answer' do
          click_on 'Комментировать'
        end
        # form for new comment is raising
        expect(page).to have_css 'form.new_comment'
        # creating comment
        fill_in 'Body', with: 'New comment'
        click_on 'Create Comment'
        # form is hiding
        expect(page).to_not have_css 'form.new_comment'
        # new comment is now showed in .question>.comments
        within '.answer>.comments' do
          expect(page).to have_content 'New comment'
        end
      end
    end
    scenario 'object and it appears to another user page' do
      Capybara.using_session('user') do
        sign_in author_of_question
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answer' do
          click_on 'Комментировать'
        end
        # form for new comment is raising
        expect(page).to have_css 'form.new_comment'
        # creating comment
        fill_in 'Body', with: 'New comment'
        click_on 'Create Comment'
        # form is hiding
        expect(page).to_not have_css 'form.new_comment'
        # new comment is now showed in .question>.comments
        within '.answer>.comments' do
          expect(page).to have_content 'New comment'
        end
      end

      Capybara.using_session('guest') do
        within '.answer>.comments' do
          expect(page).to have_content 'New comment'
        end
      end
    end
  end
end
