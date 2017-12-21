class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_commented

  def create
    @comment = @object.comments.build(comment_params)
    @comment.user = current_user
    render json: { status: 200 } if @comment.save
  end

  private

  def get_commented
    # detecting the object kind
    type = [Answer, Question].detect { |klass| params["#{klass.name.underscore}_id"] }
    # finding the object by id and vote for object by current user
    @object = type.find(params["#{type.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
