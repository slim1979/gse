class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, :gon_user, only: :create
  before_action :set_answer, except: %i[create attach]

  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params))
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    respond_with(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of? @answer
    respond_with(@answer)
  end

  def assign_best
    @answer.best_answer_switch if current_user.author_of?(@answer.question)
    respond_with(@answer)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attaches_attributes: %i[id file _destroy]).merge!(user: current_user)
  end

  def gon_user
    gon.author_id = current_user if current_user
  end
end
