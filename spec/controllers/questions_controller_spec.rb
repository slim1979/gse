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

    it 'renders show template' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    it_behaves_like 'POST #create', 'question'

    def valid_post_create
      post :create, params: { question: attributes_for(:question) }, format: :js
    end

    def invalid_post_create
      post :create, params: { question: attributes_for(:invalid_question) }, format: :js
    end

    def load_params
      @shared_params = { object: Question, render: :create }
    end
  end

  describe 'PATCH #update' do
    it_behaves_like 'PATCH #update', 'question'

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

  describe 'DELETE #destroy' do
    it_behaves_like 'DELETE #destroys', 'question'

    def delete_destroy
      delete :destroy, params: { id: question }, format: :js
    end

    def load_params
      @shared_params = { object: question, attributes: [] }
    end
  end
end
