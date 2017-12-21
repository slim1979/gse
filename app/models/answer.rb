class Answer < ApplicationRecord
  include VotesActions

  belongs_to :question
  belongs_to :user
  has_many :attaches, as: :attachable, dependent: :destroy
  has_many :votes, as: :subject, dependent: :destroy
  has_many :comments, as: :commented, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attaches, reject_if: proc { |attrib| attrib['file'].nil? }

  after_create :publish_answer

  def best_answer_switch
    transaction do
      question.answers.where(best_answer: true).update_all(best_answer: false)
      update!(best_answer: true)
    end
  end

  private

  def publish_answer
    return if errors.any?
    ActionCable.server.broadcast(
      'answers',
      ApplicationController.render(
        partial: 'answers/new_answer',
        locals: { answer: self }
      )
    )
  end
end
