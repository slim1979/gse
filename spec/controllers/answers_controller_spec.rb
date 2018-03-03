require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user2)         { create(:user) }
  let(:question)      { create(:question, user: @user) }
  let(:answer)        { create(:answer, user: @user, question: question) }
  let(:answer_attach) { create(:attach, attachable: answer) }

  sign_in_user

  describe 'POST #create' do
    def valid_post_create
      post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
    end

    def invalid_post_create
      post :create, params: { question_id: question, answer: { body: nil }, format: :js }
    end

    context 'with valid attributes' do
      it_behaves_like 'Create with valid attributes'

      def load_params
        @shared_params = { object: question.answers, render: "answers/_new_answer" }
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'Create with invalid attributes'

      def load_params
        @shared_params = { object: Answer, render: :create }
      end
    end
  end

  describe 'PATСH #update' do
    context 'Answer by it author' do
      it 'assign answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end
      it 'change answer body' do
        patch :update, params: { id: answer, answer: { body: 'some new text' }, format: :js }
        answer.reload
        expect(answer.body).to eq 'some new text'
      end
      it 'will have status 200 OK' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        answer.reload
        expect(response.status).to eq 200
        # parsed_body = JSON.parse(response.body)
        # expect(parsed_body['answer']['id']).to eq answer.id
        # expect(parsed_body['answer']['body']).to eq answer.body
      end
    end
    context 'Answer by someone else' do
      it 'will not change answer body' do
        sign_out @user
        sign_in user2
        patch :update, params: { id: answer, answer: { body: 'someone else new text' }, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'someone else new text'
        expect(answer.body).to eq answer.body
      end
    end
  end

  describe 'PATCH #best_answer' do
    context 'choise by question author' do
      before { patch :assign_best, params: { id: answer, answer: attributes_for(:answer) }, format: :js }

      it 'assigns request question to @question' do
        expect(assigns(:answer)).to eq answer
      end
      it 'change answer attributes' do
        answer.reload
        expect(answer.best_answer).to eq true
      end
      it 'render best_answer template' do
        expect(response).to render_template :assign_best
      end
    end
    context 'choise by other author' do

      before do
        sign_out @user
        sign_in user2
        patch :assign_best, params: { id: answer, answer: attributes_for(:answer) }, format: :js
      end

      it 'will not change answer attributes' do
        answer.reload
        expect(answer.best_answer).to_not eq true
        expect(answer.best_answer).to eq false
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Answer by Author' do
      it 'will decrease answers count' do
        answer
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end
    end
    context 'Answer by other author' do
      it 'will not decrease answers count' do
        answer
        sign_out @user
        sign_in user2
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end
    context 'Answer by unauthenticated user' do
      it 'will not decrease answers count' do
        answer
        sign_out @user
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
      it 'will redirect to question' do
        sign_out @user
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
