class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates_uniqueness_of :user_id, scope: :question_id

  after_create :send_subscription

  private

  def send_subscription
    SubscribeInitMailer.send_subscription_notification(user, question).deliver_later unless question.user.id == user.id
  end
end
