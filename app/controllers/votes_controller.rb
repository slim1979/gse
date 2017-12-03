class VotesController < ApplicationController

  def create
    # detecting the object kind
    vote_for = [Answer, Question].detect { |klass| params["#{klass.name.underscore}_id"] }
    # finding the object by id and vote for object by current user
    @object = vote_for.find(params["#{vote_for.name.underscore}_id"])
    @object.vote(current_user, params[:votes_value].to_i)
    render json: { object: @object, object_type: @object.class.to_s }
  end
end
