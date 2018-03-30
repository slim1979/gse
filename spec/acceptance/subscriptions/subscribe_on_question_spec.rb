require 'acceptance_helper'

feature 'User can subscribe on question', %q(
  In order to receive new answers on email
  As an authenticated user
  I want to be able to subscribe on question
) do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'Subscribe on question' do
    it 'User can see link to subscribe' do
      sign_in user
      visit question_path(question)
      expect(page).to have_link 'Подписаться'
    end
  end
end
