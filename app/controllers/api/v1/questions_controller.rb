class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: %i[show edit update destroy]

  authorize_resource

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with @question, serializer: QuestionWithoutAnswersSerializer, root: 'question'
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end
end