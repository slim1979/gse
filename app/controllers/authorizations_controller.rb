class AuthorizationsController < ApplicationController
  def confirm_email
    authorization = Authorization.find params[:id]
    user = authorization.user
    user.update!(confirmed_at: Time.now)
    authorization.update!(email: params[:email], confirmed_at: Time.now)
    redirect_to new_user_session_path
  end
end
