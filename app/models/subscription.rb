class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

  after_create :send_subscription

  private

  def send_subscription
    SubscribeInitMailer.send_subscription_confirmation(user, question).deliver_later
  end
end
