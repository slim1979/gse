require 'rails_helper'

describe 'Unauthorized' do
  %w[/ /show].each do |path|
    it "return 401 status if there is no access token on #{path}" do
      get "/api/v1/questions#{path}", params: { format: :json }
      expect(response.status).to eq 401
    end

    it "return 401 status if access token is invalid on #{path}" do
      get "/api/v1/questions#{path}", params: { format: :json, access_token: '1213131' }
      expect(response.status).to eq 401
    end
  end
end

describe 'GET index' do
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
      expect(response.body).to have_json_size(4).at_path('questions')
    end

    %w[id title body created_at updated_at].each do |attr|
      it "questions contain #{attr}" do
        expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
      end
    end

    context 'answers' do
      it 'included in question object' do
        expect(response.body).to have_json_size(1).at_path("questions/0/answers")
      end

      %w[id body created_at updated_at].each do |attr|
        it "contain #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
        end
      end
    end
  end
end

describe 'GET show' do
  let(:access_token) { create(:access_token) }
  let(:user)         { create(:user) }
  let!(:question)    { create(:question, user: user) }
  let!(:answer)      { create(:answer, question: question, user: user) }
  let!(:comment)     { create(:comment, commented: question, user: user) }
  let!(:attach)      { create(:attach, attachable: question) }

  before do
    get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }
  end

  it 'return status 200' do
    expect(response).to be_success
  end

  %w[id title body created_at updated_at].each do |attr|
    it "contain question #{attr}" do
      expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
    end
  end

  %w[answers comments attaches].each do |path|
    it "contain #{path}" do
      expect(response.body).to have_json_size(1).at_path("question/#{path}")
    end
  end

  it 'attachment object contains url' do
    expect(response.body).to be_json_eql(attach.file.url.to_json).at_path('question/attaches/0/file/url')
  end
end
