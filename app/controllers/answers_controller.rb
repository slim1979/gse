class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, except: :destroy

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    redirect_to @question

    if current_user.author_of? @answer
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted!'
    else
      flash[:alert] = 'You can delete only your own content'
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
