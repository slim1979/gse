class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  respond_to :js
  authorize_resource

  def create
    @subscription = Subscription.create(user: current_user, question_id: params[:id])
    respond_with(@subscription)
  end

  def destroy
    @subscription = Subscription.where(user: current_user, question_id: params[:id]).first
    respond_with(@subscription.destroy)
  end
end
