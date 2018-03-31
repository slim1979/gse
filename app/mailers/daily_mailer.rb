class DailyMailer < ApplicationMailer
  def digest(email, questions)
    @yesterday_questions = questions
    mail(to: email, subject: 'Дайджест')
  end
end
