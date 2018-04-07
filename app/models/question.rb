class Question < ApplicationRecord
  include VotesActions

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :attaches, as: :attachable, dependent: :destroy
  has_many :votes, as: :subject, dependent: :destroy
  has_many :comments, as: :commented, dependent: :destroy

  scope :created_yesterday, -> { where(created_at: (Time.current.localtime.yesterday.beginning_of_day..Time.current.localtime.yesterday.end_of_day)) }

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attaches, reject_if: proc { |attrib| attrib['file'].nil? }
  after_create_commit :publish_question
  after_update_commit :update_question
  after_destroy_commit :destroy_question

  private

  def publish_question
    return if errors.any?
    CreateQuestionJob.perform_later(user, self)
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        json: { publish: { question: self, author: user } }
      )
    )
  end

  def update_question
    return if errors.any?
    ["questions/#{id}/question_update", "questions"].each do |stream|
      ActionCable.server.broadcast(
      stream,
      ApplicationController.render(
        json: { update: { question: self } }
        )
      )
    end
  end

  def destroy_question
    return if errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        json: { destroy: { question: self } }
      )
    )
  end
end
