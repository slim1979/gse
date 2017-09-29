class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, except: :create

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
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

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
