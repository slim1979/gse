class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  def new
    @question = Question.new
    @question.attaches.new
  end

  def index
    @question = Question.new
    @question.attaches.new
    @questions = Question.all
  end

  def create
    @question = current_user.questions.new(question_params)

    render json: @question, status: 200 if @question.save
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
end
