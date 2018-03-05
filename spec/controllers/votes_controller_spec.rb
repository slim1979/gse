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

    context 'answer' do
      it_behaves_like 'votes', 'answer'

      def load_params
        @shared_params = { object: answer }
      end
    end

    context 'question' do
      it_behaves_like 'votes', 'question'

      def load_params
        @shared_params = { object: question }
      end
    end
  end
end
