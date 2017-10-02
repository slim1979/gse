class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def turn_off_old_best_answer
    answers.find(best_answer).update(best_answer: false) if best_answer
  end

  def turn_on_new_best_answer
    answers.find(best_answer).update(best_answer: true) if best_answer
  end
end
