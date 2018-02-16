class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commented

  respond_to :html

  authorize_resource

  def create
    respond_with(@comment = @object.comments.create(body: comment_params[:body], user: current_user))
  end

  private

  def load_commented
    # detecting the object kind
    type = [Answer, Question].detect { |klass| params["#{klass.name.underscore}_id"] }
    # finding the object by id
    @object = type.find(params["#{type.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
