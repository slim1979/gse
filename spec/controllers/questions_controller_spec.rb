require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user2)     { create(:user) }
  # the better way to assign variable instead of @questions = FactoryBot.create_list etc...
  # FactoryBot. no longer needed, since we add config.include FactoryBot::Syntax::Methods in rails_helper.rb
  let(:questions) { create_list(:question, 2, user: @user) }
  let(:question)  { questions.first }
  let(:answer)    { create(:answer, question: question, user: @user) }
  let(:attach)    { create(:attach, attachable: question) }

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
    # it 'build new attachment to answer' do
    #   expect(assigns(:answer).attaches.first).to be_a_new(Attach)
    # end
    it 'renders show template' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    def valid_post_create
      post :create, params: { question: attributes_for(:question) }, format: :js
    end

    def invalid_post_create
      post :create, params: { question: attributes_for(:invalid_question) }, format: :js
    end

    def load_params
      @shared_params = { object: Question, render: :create }
    end

    it_behaves_like 'Create with valid attributes'

    it_behaves_like 'Create with invalid attributes'
  end

  describe 'PATCH #update question by it autor' do
    it_behaves_like 'Update by author'

    def valid_patch_update
      patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
    end

    def invalid_patch_update
      patch :update, params: { id: question, question: { title: nil, body: nil } }, format: :js
    end

    def load_params
      @shared_params = { object: question, attributes: %w[title body] }
    end
  end

  describe 'PATCH #update question by authenticated someone else' do
    context 'with valid attributes' do
      before do
        sign_out @user
        sign_in user2

        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
      end

      it 'will not change question attributes' do
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'Question by it author' do
      before { question }

      it 'delete question' do
        expect { delete :destroy, params: { id: question }, format: :js }.to change(Question, :count).by(-1)
      end
      it 'redirect to index view' do
        delete :destroy, params: { id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Question by other author' do
      before { question }

      it 'will not delete question' do
        sign_in user2
        expect { delete :destroy, params: { id: question }, format: :js }.to_not change(Question, :count)
      end
    end
  end
end
