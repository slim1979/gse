require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    # the better way to assign variable instead of @questions = FactoryGirl.create_list etc...
    let(:questions) {
      create_list(:question, 2) # FactoryGirl. no longer needed, since we add config.include FactoryGirl::Syntax::Methods in rails_helper.rb
    }
    before { get :index }
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

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
    let(:question) { create(:question) }

    before { get :edit, params: { id: question } }

    it 'assign request question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders edit template' do
      expect(response).to render_template :edit
    end

  end
end
