require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }
  let(:user)         { create(:user) }
  let!(:questions)   { create_list(:question, 4, user: user) }
  let!(:question)    { questions.first }
  let!(:answer)      { create(:answer, question: question, user: user) }

  def success_response
    expect(response).to be_success
  end

  describe 'GET index' do

    it_behaves_like 'Unauthorized'

    before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token} }

    it 'will return status 200' do
      success_response
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

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET show' do
    let!(:comment)     { create(:comment, commented: question, user: user) }
    let!(:attach)      { create(:attach, attachable: question) }

    it_behaves_like 'Unauthorized'

    before do
      get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }
    end

    it 'return status 200' do
      success_response
    end

    %w[id title body created_at updated_at].each do |attr|
      it "contain question #{attr}" do
        expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
      end
    end

    %w[comments attaches].each do |path|
      it "contain #{path}" do
        expect(response.body).to have_json_size(1).at_path("question/#{path}")
      end
    end

    it 'attachment object contains url' do
      expect(response.body).to be_json_eql(attach.file.url.to_json).at_path('question/attaches/0/file/url')
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST create' do
    let(:valid_post_create)  { post '/api/v1/questions', params: { format: :json, question: attributes_for(:question), user: user, access_token: access_token.token } }
    let(:invalid_post_create){ post '/api/v1/questions', params: { format: :json, question: attributes_for(:invalid_question), access_token: access_token.token, user: user } }
    it_behaves_like 'Unauthorized'

    context 'with valid attributes' do
      before do
        valid_post_create
      end

      it 'return status 200' do
        success_response
      end

      it 'return question object' do
        expect { post '/api/v1/questions', params: { format: :json, question: attributes_for(:question), user: user, access_token: access_token.token } }.to change(Question, :count).by(1)
      end

      %w[id title body created_at updated_at votes_count user_id].each do |attrib|
        it "contain question #{attrib}" do
          expect(response.body).to be_json_eql(Question.last.send(attrib.to_sym).to_json).at_path("question/#{attrib}")
        end
      end
    end
    context 'with invalid attributes' do
      before do
        invalid_post_create
      end

      it 'return status unprocessible entity' do
        expect(response.status).to eq 422
      end

      it 'will not create question' do
        expect{ invalid_post_create }.to_not change(Question, :count)
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end
end
