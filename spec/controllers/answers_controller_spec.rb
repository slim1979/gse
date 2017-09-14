require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    it 'assign a new question to @question' do
      get :new, params: { question_id: question }
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'renders new view' do
      get :new, params: { question_id: question }
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end
      it 'redirect to show' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer_path(assigns(:answer))
      end
    end
    context 'with invalid attributes' do
      it 'does not save answer to db' do
        expect { post :create, params: { question_id: question, answer: { body: nil } } }.to_not change(Answer, :count)
      end
      it 're-render template new' do
        post :create, params: { question_id: question, answer: { body: nil } }
        expect(response).to render_template :new
      end
    end
  end
end
