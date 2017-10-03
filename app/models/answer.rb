class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def best_answer_switch
    transaction do
      question.answers.where(best_answer: true).update_all(best_answer: false)
      update(best_answer: true)
    end
  end
end
