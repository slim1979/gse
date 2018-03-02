require 'rails_helper'

describe 'Answers API' do
  let(:access_token)  { create(:access_token) }
  let(:user)          { create(:user) }
  let!(:question)     { create(:question, user: user) }
  let!(:answers)      { create_list(:answer, 5, question: question, user: user) }
  let!(:answer)       { answers.first }
  let!(:comments)     { create_list(:comment, 5, commented: answer, user: user) }
  let!(:comment)      { comments.first }
  let!(:attach)       { create(:attach, attachable: answer) }

  def success_response
    expect(response).to be_success
  end

  describe 'GET index' do

    before do
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }
    end

    it 'return status 200' do
      success_response
    end

    it 'contain answers list' do
      expect(response.body).to have_json_size(5).at_path('answers')
    end

    %w[id body created_at updated_at votes_count best_answer user_id].each do |attrib|
      it "contain #{attrib}" do
        expect(response.body).to be_json_eql(answer.send(attrib.to_sym).to_json).at_path("answers/0/#{attrib}")
      end
    end
  end

  describe 'GET show' do
    before do
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json, access_token: access_token.token }
    end

    it 'return status 200' do
      success_response
    end

    %w[id body question_id created_at updated_at user_id best_answer votes_count].each do |attrib|
      it "contain answer #{attrib}" do
        expect(response.body).to be_json_eql(answer.send(attrib.to_sym).to_json).at_path("answer/#{attrib}")
      end
    end

    context 'comments' do
      it 'includes comments list' do
        expect(response.body).to have_json_size(5).at_path('answer/comments')
      end

      %w[id body created_at updated_at].each do |attrib|
        it "comment contains #{attrib}" do
          expect(response.body).to be_json_eql(comment.send(attrib.to_sym).to_json).at_path("answer/comments/0/#{attrib}")
        end
      end
    end

    context 'attaches' do
      it 'includes attaches list' do
        expect(response.body).to have_json_size(1).at_path('answer/attaches')
      end

      %w[id file attachable_id attachable_type created_at updated_at].each do |attrib|
        it "attaches contains #{attrib}" do
          expect(response.body).to be_json_eql(attach.send(attrib.to_sym).to_json).at_path("answer/attaches/0/#{attrib}")
        end

        it 'file contain file url' do
          expect(response.body).to be_json_eql(attach.file.url.to_json).at_path("answer/attaches/0/file/url")
        end
      end
    end
  end

  describe 'POST create' do
    let(:valid_post_create) { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer), user: user, access_token: access_token.token } }
    let(:invalid_post_create) { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: { body: nil }, user: user, access_token: access_token.token } }

    context 'with valid attributes' do
      before do
        valid_post_create
      end

      it 'return status 200' do
        success_response
      end

      it 'return question object' do
        expect { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer), user: user, access_token: access_token.token } }.to change(Answer, :count).by(1)
      end

      %w[id body created_at updated_at votes_count user_id].each do |attrib|
        it "contain question #{attrib}" do
          expect(response.body).to be_json_eql(Answer.last.send(attrib.to_sym).to_json).at_path("answer/#{attrib}")
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
        expect{ invalid_post_create }.to_not change(Answer, :count)
      end
    end
  end
end
