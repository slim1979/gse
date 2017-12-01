class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, except: %i[create attach]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      render partial: 'answers/new_answer'
    else
      render partial: 'answers/errors', status: 422
    end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)

    render json: @answer.as_json unless @answer.errors.present?
    render partial: 'common/errors', resource: @answer, status: 422 if @answer.errors.present?
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.author_of? @answer
  end

  def assign_best
    if current_user.author_of?(@answer.question)
      @answer.best_answer_switch
    else
      @error = true
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
    params.require(:answer).permit(:body, attaches_attributes: %i[id file _destroy])
  end
end
