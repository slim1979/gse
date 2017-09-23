require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: @user) }
  # the better way to assign variable instead of @questions = FactoryGirl.create_list etc...
  # FactoryGirl. no longer needed, since we add config.include FactoryGirl::Syntax::Methods in rails_helper.rb
  let(:questions) { create_list(:question, 2, user: @user) }

  describe 'GET #index' do
    sign_in_user
    before { get :index }
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    sign_in_user
    before { get :show, params: { id: question } }

    it 'assign request question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns new Question to a @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'renders template new' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, params: { id: question } }

    it 'assign request question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders edit template' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
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

  describe 'PATCH #update' do
    sign_in_user
    context 'valid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question) } }

      it 'assigns request question to @question' do
        expect(assigns(:question)).to eq question
      end
      it 'change question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 'redirect to updated question' do
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: question, question: { title: nil, body: nil } } }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to_not eq nil
        expect(question.title).to eq question.title
        expect(question.body).to_not eq nil
        expect(question.body).to eq question.body
      end
      it 're-render edit template' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'Question by it author' do
      sign_in_user
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
      sign_in_user
      before { question }

      it 'will not delete question' do
        sign_out @user
        sign_in user2
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
      it 'redirect to index view' do
        sign_out @user
        sign_in user2
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
