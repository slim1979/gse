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

  def create
    @question = current_resource_owner.questions.create(question_params)
    respond_with @question
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :best_answer, attaches_attributes: %i[id _destroy file])
  end
end
