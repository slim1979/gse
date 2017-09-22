require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, user: @user) }
  let(:answer)   { create(:answer, user: @user, question: question) }

  sign_in_user

  describe 'POST #create' do
    let(:valid_post_create) { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
    let(:invalid_post_create) { post :create, params: { question_id: question, answer: { body: nil } } }

    context 'with valid attributes' do
      it 'saves answer to database' do
        expect { valid_post_create }.to change(question.answers, :count).by(1)
      end
      it 'redirect to show' do
        valid_post_create
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer to db' do
        expect { invalid_post_create }.to_not change(Answer, :count)
      end
      it 're-render template new' do
        invalid_post_create
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
