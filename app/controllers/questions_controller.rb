class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  def new
    @question = Question.new
  end

  def index
    @questions = Question.all
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question
      flash[:notice] = 'Your question created successfully!'
    else
      render :new
    end
  end

  def show; end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def destroy
    redirect_to questions_path

    if current_user.author_of? @question
      @question.destroy
      flash[:notice] = 'Your question successfully deleted!'
    else
      flash[:alert] = 'You can delete only your own content'
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :best_answer)
  end
end
