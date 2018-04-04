require 'acceptance_helper'

feature 'User can subscribe on question', %q(
  In order to receive new answers on email
  As an authenticated user
  I want to be able to subscribe on question
) do

  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question) }

  describe 'Subscribe on question', js: true do
    before do
      Sidekiq::Worker.clear_all
      sign_in user
      visit question_path(question)
    end

    it 'User can see link to subscribe' do
      expect(page).to have_link 'Подписаться'
    end

    it 'Click on link \'Подписаться\' will change button title', js: true do
      click_on 'Подписаться'
      within '.subscribe' do
        expect(page).to_not have_link 'Подписаться'
        expect(page).to have_content 'Подписаны'
      end
    end

    context 'creating answer on question by other user', js: true do
      before do
        click_on 'Подписаться'
        sign_out
        sign_in user2
        visit question_path(question)
      end

      it 'will send an email' do
        fill_in :answer_body, with: 'some new answer'
        click_on 'Answer the question'
        sleep 1
        open_email(user.email)
        expect(current_email.body).to have_content question.title
      end
    end
  end
end
