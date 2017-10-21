class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, except: %i[create attach]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        format.html { render partial: 'answers/answers', layouts: false }
        format.json { render json: @answer }
      else
        format.html { render html: @answer.errors.full_messages.join("\n"), status: 422 }
        format.json { render json: @answer.errors.full_messages, status: 422 }
      end
    end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.author_of? @answer
  end

  def best_answer_assign
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
