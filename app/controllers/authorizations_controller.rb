class AuthorizationsController < ApplicationController
  def confirm_email
    authorization = Authorization.find params[:id]
    authorization.update!(email: params[:email], confirmed_at: Time.now)
    redirect_to new_user_session_path
  end
end
