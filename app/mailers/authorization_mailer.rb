class AuthorizationMailer < ApplicationMailer
  def confirm_email(user, authorization)
    @user = user
    @email = user.email
    @authorization = authorization

    mail(to: user.email, subject: 'Подтвердите адрес почты')
  end
end
