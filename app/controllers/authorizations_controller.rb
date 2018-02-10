class AuthorizationsController < ApplicationController
  def confirm_email
    authorization = Authorization.confirm_me_with(params[:id], params[:email])
    flash[:notice] = "Рады приветствовать Вас на нашем сайте! Вход осуществлен с помощью #{authorization.provider.capitalize}"
    sign_in_and_redirect authorization.user, event: :authentication
  end
end
