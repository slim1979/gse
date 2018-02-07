class AuthorizationsController < ApplicationController
  def confirm_email
    authorization = Authorization.find params[:id]
    user = authorization.user
    user.update!(confirmed_at: Time.now)
    authorization.update!(email: params[:email], confirmed_at: Time.now)
    flash[:notice] = "Рады приветствовать Вас на нашем сайте! Вход осуществлен с помощью #{authorization.provider.capitalize}"
    sign_in_and_redirect user, event: :authentication
  end
end
