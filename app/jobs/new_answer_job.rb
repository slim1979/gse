class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.in_groups_of(100) do |group|
      group.compact!
      group.each do |subscription|
        NewAnswerMailer.send_notification(subscription.user, answer.question, answer).deliver_later
      end
    end
  end
end
