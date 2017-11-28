require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  let(:user)      { create(:user) }
  let(:user2)     { create(:user) }
  let(:question)  { create(:question, user: user) }
  let!(:answer)   { create(:answer, user: user2, question: question) }

  describe 'PATCH#any' do
    let(:vote_like_for_answer) { patch :any, params: { subject_type: Answer, subject_id: answer.id, votes_value: 1 }, format: :json }
    let(:vote_dislike_for_answer) { patch :any, params: { subject_type: Answer, subject_id: answer.id, votes_value: -1 }, format: :json }

    it 'vote \'like\' for answer will increase its rating' do
      sign_in user
      expect {
        vote_like_for_answer
        answer.reload
      }.to change(answer, :votes_count).by(1)
    end

    it 'vote \'dislike\' for answer will decrease its rating' do
      sign_in user
      expect {
        vote_dislike_for_answer
        answer.reload
      }.to change(answer, :votes_count).by(-1)
    end
  end
end
