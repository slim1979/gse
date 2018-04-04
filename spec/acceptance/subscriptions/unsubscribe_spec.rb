require 'acceptance_helper'

feature 'User can unsubscribe from question', %q(
  In order to cancel subscription in question
  As an subscribed user
  I want to be able to unsubscribe from question
) do

  let(:user)          { create(:user) }
  let(:question)      { create(:question) }
  let!(:subscription) { create(:subscription, user: user, question: question) }

  describe 'Unsubscribe from question', js: true do
    it 'will change button value' do
      sign_in user

      visit question_path(question)
      click_on 'Отписаться'
      expect(page).to_not have_content 'Отписаться'
      expect(page).to have_content 'Подписка снята'
    end
  end
end
