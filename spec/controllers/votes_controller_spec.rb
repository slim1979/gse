require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  let!(:user)      { create(:user) }
  let!(:user2)     { create(:user) }
  let!(:question) { create(:question, user: user2) }
  let!(:answer)   { create(:answer, user: user2, question: question) }

  describe 'POST#create' do
    let(:vote_like_for_answer) { post :create, params: { answer_id: answer, votes_value: 1 }, format: :json }
    let(:vote_dislike_for_answer) { post :create, params: { answer_id: answer, votes_value: -1 }, format: :json }
    let(:vote_like_for_question) { post :create, params: { question_id: question, votes_value: 1 }, format: :json }
    let(:vote_dislike_for_question) { post :create, params: { question_id: question, votes_value: -1 }, format: :json }

    before { sign_in user }

    it 'vote \'like\' for answer will increase its rating' do
      expect {
        vote_like_for_answer
        answer.reload
      }.to change(answer, :votes_count).by(1)
    end

    it 'vote \'dislike\' for answer will decrease its rating' do
      expect {
        vote_dislike_for_answer
        answer.reload
      }.to change(answer, :votes_count).by(-1)
    end

    it 'vote \'like\' for question will increase its rating' do
      expect {
        vote_like_for_question
        question.reload
      }.to change(question, :votes_count).by(1)
    end

    it 'vote \'dislike\' for question will decrease its rating' do
      expect {
        vote_dislike_for_question
        question.reload
      }.to change(question, :votes_count).by(-1)
    end
  end
end
