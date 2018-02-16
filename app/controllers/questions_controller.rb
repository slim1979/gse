class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :gon_user, unless: :devise_controller?

  respond_to :html, only: %i[index show]
  respond_to :js, except: %i[index show]

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def show
    respond_with @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
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
