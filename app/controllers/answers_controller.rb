class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
