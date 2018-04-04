require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user2)         { create(:user) }
  let!(:question)     { create(:question) }
  let(:subscription)  { create(:subscription, question: question, user: @user) }

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

  describe 'DELETE #destroy' do
    it_behaves_like 'DELETE #destroys', 'subscription'

    def delete_destroy
      delete :destroy, params: { id: question, format: :js }
    end

    def load_params
      @shared_params = { object: subscription, render: :destroy }
    end
  end
end
