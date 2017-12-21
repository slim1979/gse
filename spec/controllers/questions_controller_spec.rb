require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: @user) }
  # the better way to assign variable instead of @questions = FactoryGirl.create_list etc...
  # FactoryGirl. no longer needed, since we add config.include FactoryGirl::Syntax::Methods in rails_helper.rb
  let(:questions) { create_list(:question, 2, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let(:attach) { create(:attach, attachable: question) }
  let(:response_is_equal_with_assigns_question) {
    parsed_body = JSON.parse(response.body)
    question_as_json = assigns(:question).as_json
    parsed_body['created_at'] = parsed_body['created_at'].to_time.localtime.strftime('%d/%m/%Y, %T')
    parsed_body['updated_at'] = parsed_body['updated_at'].to_time.localtime.strftime('%d/%m/%Y, %T')
    question_as_json['created_at'] = question_as_json['created_at'].to_time.localtime.strftime('%d/%m/%Y, %T')
    question_as_json['updated_at'] = question_as_json['updated_at'].to_time.localtime.strftime('%d/%m/%Y, %T')
    expect(parsed_body).to eq question_as_json
  }

  sign_in_user

  describe 'GET #index' do
    before { get :index, format: :js }
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question }, format: :js }

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

  describe 'POST #create' do
    let(:valid_post_create) { post :create, params: { question: attributes_for(:question) }, format: :json }
    let(:invalid_post_create) { post :create, params: { question: attributes_for(:invalid_question) }, format: :json }

    context 'with valid attributes' do
      it 'saves new question to DB' do
        # attributes_for returns a hash of attributes from factory girl
        # which is create a question object
        expect { valid_post_create }.to change(Question, :count).by(1)
      end
      it 'will render question as json' do
        valid_post_create
        response_is_equal_with_assigns_question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new question to DB' do
        expect { invalid_post_create }.to_not change(Question, :count)
      end
      it 're-renders new template' do
        invalid_post_create
        expect(response).to render_template :_errors
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
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: question, question: { title: nil, body: nil } }, format: :json }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to_not eq nil
        expect(question.title).to eq question.title
        expect(question.body).to_not eq nil
        expect(question.body).to eq question.body
      end
      it 're-render edit template' do
        expect(response).to render_template 'questions/_errors'
      end
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
        expect { delete :destroy, params: { id: question} }.to change(Question, :count).by(-1)
      end
      it 'redirect to index view' do
        delete :destroy, params: { id: question}
        response_is_equal_with_assigns_question
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
        expect(response.status).to eq 422
        expect(response.body).to have_content 'У Вас недостаточно прав на это действие. Обратитесь в техподдержку.'
      end
    end
  end
end
