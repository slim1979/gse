class DailyMailer < ApplicationMailer
  def send_daily_digest(user, questions)
    @yesterday_questions = questions
    mail(to: user.email, subject: 'Дайджест', questions: questions)
  end
end
