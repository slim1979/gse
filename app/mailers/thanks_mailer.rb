class ThanksMailer < ApplicationMailer
  def send_thanks(user, question)
    @question = question
    mail(to: user.email, subject: 'Благодарим за Ваш вопрос')
  end
end
