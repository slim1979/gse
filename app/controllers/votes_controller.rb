class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_object

  respond_to :json

  authorize_resource

  def create
    @object.vote(current_user, params[:votes_value].to_i)
    respond_with(@object)
  end

  private

  def load_object
    # detecting the object kind
    vote_for = [Answer, Question].detect { |klass| params["#{klass.name.underscore}_id"] }
    # finding the object by id and vote for object by current user
    @object = vote_for.find(params["#{vote_for.name.underscore}_id"])
  end
end
