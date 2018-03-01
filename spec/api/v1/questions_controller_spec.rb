require 'rails_helper'

describe 'GET index' do
  describe 'unauthorized' do
    it "return 401 status if there is no access token on index" do
      get '/api/v1/questions', params: { format: :json }
      expect(response.status).to eq 401
    end

    it "return 401 status if access token is invalid on index" do
      get '/api/v1/questions', params: { format: :json, access_token: '1213131' }
      expect(response.status).to eq 401
    end
  end

  describe 'authorized' do
    let(:access_token) { create(:access_token) }
    let(:user)         { create(:user) }
    let!(:questions)   { create_list(:question, 4, user: user) }
    let(:question)     { questions.first }
    let!(:answer)      { create(:answer, question: question, user: user) }

    before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token} }

    it 'will return status 200' do
      expect(response).to be_success
    end

    it 'returns list of questions' do
      expect(response.body).to have_json_size(4)
    end

    %w[id title body created_at updated_at].each do |attr|
      it "questions contain #{attr}" do
        expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    context 'answers' do
      it 'included in question object' do
        expect(response.body).to have_json_size(1).at_path("0/answers")
      end

      %w[id body created_at updated_at].each do |attr|
        it "contain #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
        end
      end
    end
  end
end
