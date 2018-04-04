class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    questions = Question.created_yesterday.to_a
    User.pluck(:email).in_groups_of(100) do |group|
      group.compact!.each do |email|
        DailyMailer.digest(email, questions).deliver_later
      end
    end
  end
end
