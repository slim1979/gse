class CreateQuestionJob < ApplicationJob
  queue_as :default

  def perform(user, question)
    question.subscriptions.create(user: user, question: question)
    ThanksMailer.send_thanks(user, question).deliver_now
  end
end
