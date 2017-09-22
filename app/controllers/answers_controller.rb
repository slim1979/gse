class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, except: :destroy

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of? @answer
      @question = @answer.question
      @answer.destroy
      redirect_to @question
      flash[:notice] = 'Your answer was successfully deleted!'
    else
      redirect_to @question
      flash[:notice] = 'You can delete only your own content'
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
