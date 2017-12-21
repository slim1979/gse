class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :gon_user, unless: :devise_controller?

  def index
    @question = Question.new
    @question.attaches.new
    @questions = Question.all
  end

  def create
    @question = current_user.questions.create(question_params)
    render json: { status: 200 } unless @question.errors.present?
    render partial: 'questions/errors', status: 422 if @question.errors.present?
  end

  def show
    @answer = @question.answers.new
    @answer.attaches.build
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)

    if @question.errors.any?
      render partial: 'questions/errors', status: 422
    else
      render json: @question
    end
  end

  def destroy
    if current_user.author_of? @question
      @question.destroy
      render json: @question
    else
      render json: { alert: 'У Вас недостаточно прав на это действие. Обратитесь в техподдержку.' }, status: 422
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :best_answer, attaches_attributes: %i[id _destroy file])
  end

  def gon_user
    gon.author_id = current_user.id if current_user
  end
end
