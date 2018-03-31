class SubscribeInitMailer < ApplicationMailer
  def send_subscription_confirmation(user, question)
    mail(to: user.email, subject: "Вы подписались на вопрос #{question.title}")
  end
end
