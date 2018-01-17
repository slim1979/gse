require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user2)         { create(:user) }
  let(:question)      { create(:question, user: @user) }
  let(:answer)        { create(:answer, user: @user, question: question) }
  let(:answer_attach) { create(:attach, attachable: answer) }

  sign_in_user

  describe 'POST #create' do
    let(:valid_post_create) { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }
    let(:invalid_post_create) { post :create, params: { question_id: question, answer: { body: nil }, format: :js } }

    context 'with valid attributes' do
      it 'saves answer to database' do
        expect { valid_post_create }.to change(question.answers, :count).by(1)
      end
      it 'redirect to show' do
        valid_post_create
        expect(response).to render_template "answers/_new_answer"
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer to db' do
        expect { invalid_post_create }.to_not change(Answer, :count)
      end
      it 'will return unprocessable entity error' do
        invalid_post_create
        expect(response.status).to eq 200
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
      it 'render best_answer template' do
        expect(response).to render_template :assign_best
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
      it 'will render destroy template' do
        sign_out @user
        sign_in user2
        delete :destroy, params: { id: answer }, format: :js
        response_body = JSON.parse(response.body)
        expect(response_body['alert']).to eq 'У Вас недостаточно прав на это действие. Обратитесь в техподдержку.'
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
