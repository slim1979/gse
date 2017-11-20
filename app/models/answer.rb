class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attaches, as: :attachable, dependent: :destroy
  has_many :votes, as: :subject, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attaches, reject_if: proc { |attrib| attrib['file'].nil? }

  def best_answer_switch
    transaction do
      question.answers.where(best_answer: true).update_all(best_answer: false)
      update!(best_answer: true)
    end
  end
end
