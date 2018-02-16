class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, :gon_user, only: :create
  before_action :set_answer, except: %i[create attach]

  respond_to :js

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params))
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    # @answer.destroy
    respond_with(@answer.destroy)
  end

  def assign_best
    @answer.best_answer_switch
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
