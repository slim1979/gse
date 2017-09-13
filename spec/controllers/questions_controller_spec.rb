require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    # the better way to assign variable instead of @questions = FactoryGirl.create_list etc...
    # FactoryGirl. no longer needed, since we add config.include FactoryGirl::Syntax::Methods in rails_helper.rb
    let(:questions) { create_list(:question, 2) }

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
    it 'renders show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns new Question to a @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'renders template new' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    it 'assign request question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders edit template' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      it 'saves new question to DB' do
        # attributes_for returns a hash of attributes from factory girl
        # which is create a question object
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      it 'redirect to show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new question to DB' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end
      it 're-renders new template' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do

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
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end
      it 're-render edit template' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { question }

    it 'delete question' do
      expect { delete :destroy, params: { id: question} }.to change(Question, :count).by(-1)
    end
    it 'redirect to index view' do
      delete :destroy, params: { id: question}
      expect(response).to redirect_to questions_path
    end
  end

end
