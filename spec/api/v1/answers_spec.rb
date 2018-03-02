require 'rails_helper'

describe 'Answers API' do
  describe 'GET index' do
    let(:access_token) { create(:access_token) }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 5, question: question, user: user) }
    let(:answer) { answers.first }

    before do
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }
    end

    it 'return status 200' do
      expect(response).to be_success
    end

    it 'contain answers list' do
      expect(response.body).to have_json_size(5).at_path('answers')
    end

    %w[id body created_at updated_at votes_count best_answer user_id].each do |attrib|
      it "contain #{attrib}" do
        expect(response.body).to be_json_eql(answer.send(attrib.to_sym).to_json).at_path("answers/0/#{attrib}")
      end
    end

    it 'some' do
      # expect(answers.map(&:id).first).to eq answer.id
      expect(response.body.pathmap.to_json).to_not eq answer.id
    end
  end
  describe 'GET show'
end
