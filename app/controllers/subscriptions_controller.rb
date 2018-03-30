class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  respond_to :js
  authorize_resource

  def create
    @subscription = Subscription.create(user: current_user, question_id: params[:id])
    respond_with(@subscription)
  end
end
