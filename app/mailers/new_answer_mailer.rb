class NewAnswerMailer < ApplicationMailer
  def send_notification(user, question, answer)
    @answer = answer
    @question = question
    mail(to: user.email, subject: "Новый ответ на вопрос: #{question.title}")
  end
end
