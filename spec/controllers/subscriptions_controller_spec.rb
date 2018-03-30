require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user)             { create(:user) }
  let(:question)         { create(:question, user: user) }

  sign_in_user

  describe 'POST #create' do
    it_behaves_like 'POST #create', 'subscription'

    def valid_post_create
      post :create, params: { id: question, format: :js }
    end

    def invalid_post_create
      post :create, params: { id: nil, format: :js }
    end

    def load_params
      @shared_params = { object: Subscription, render: :create }
    end
  end
end
