require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: @user) }
  # the better way to assign variable instead of @questions = FactoryGirl.create_list etc...
  # FactoryGirl. no longer needed, since we add config.include FactoryGirl::Syntax::Methods in rails_helper.rb
  let(:questions) { create_list(:question, 2, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let(:attach) { create(:attach, attachable: question) }

  sign_in_user

  describe 'GET #index' do
    before { get :index }
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assign request question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'build new attachment to answer' do
      expect(assigns(:answer).attaches.first).to be_a_new(Attach)
    end
    it 'renders show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns new Question to a @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'build new attachment to question' do
      expect(assigns(:question).attaches.first).to be_a_new(Attach)
    end
    it 'renders template new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:valid_post_create) { post :create, params: { question: attributes_for(:question) } }
    let(:invalid_post_create) { post :create, params: { question: attributes_for(:invalid_question) } }

    context 'with valid attributes' do
      it 'saves new question to DB' do
        # attributes_for returns a hash of attributes from factory girl
        # which is create a question object
        expect { valid_post_create }.to change(Question, :count).by(1)
      end
      it 'redirect to show' do
        valid_post_create
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new question to DB' do
        expect { invalid_post_create }.to_not change(Question, :count)
      end
      it 're-renders new template' do
        invalid_post_create
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update question by it autor' do
    context 'valid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question) }, format: :js }

      it 'assigns request question to @question' do
        expect(assigns(:question)).to eq question
      end
      it 'change question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 're-render show template' do
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: question, question: { title: nil, body: nil } }, format: :js }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to_not eq nil
        expect(question.title).to eq question.title
        expect(question.body).to_not eq nil
        expect(question.body).to eq question.body
      end
      it 're-render edit template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #update question by authenticated someone else' do
    context 'valid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question) }, format: :js }

      it 'will not change question attributes' do
        sign_out @user
        sign_in user2

        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end
      it 're-render show template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'Question by it author' do
      before { question }

      it 'delete question' do
        expect { delete :destroy, params: { id: question} }.to change(Question, :count).by(-1)
      end
      it 'redirect to index view' do
        delete :destroy, params: { id: question}
        expect(response).to redirect_to questions_path
      end
    end

    context 'Question by other author' do
      before { question }

      it 'will not delete question' do
        sign_in user2
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
      it 'redirect to index view' do
        sign_in user2
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
