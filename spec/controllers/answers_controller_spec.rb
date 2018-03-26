require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user2)         { create(:user) }
  let(:question)      { create(:question, user: @user) }
  let(:answer)        { create(:answer, user: @user, question: question) }
  let(:answer_attach) { create(:attach, attachable: answer) }

  sign_in_user

  describe 'POST #create' do
    it_behaves_like 'POST #create', 'answer'

    def valid_post_create
      post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
    end

    def invalid_post_create
      post :create, params: { question_id: question, answer: { body: nil }, format: :js }
    end

    def load_params
      @shared_params = { object: question.answers, render: "answers/_new_answer" }
    end
  end

  describe 'PATСH #update' do
    it_behaves_like 'PATCH #update', 'answer'

    def valid_patch_update
      patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
    end

    def invalid_patch_update
      patch :update, params: { id: answer, answer: { body: nil }, format: :js }
    end

    def load_params
      @shared_params = { object: answer, attributes: ['body'] }
    end
  end

  describe 'PATCH #best_answer' do
    context 'choise by question author' do
      before { patch :assign_best, params: { id: answer, answer: attributes_for(:answer) }, format: :js }

      it 'assigns request answer to @answer' do
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
    it_behaves_like 'DELETE #destroys', 'question'

    def delete_destroy
      delete :destroy, params: { id: answer }, format: :js
    end

    def load_params
      @shared_params = { object: answer, attributes: [] }
    end
  end
end
