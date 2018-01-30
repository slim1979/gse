class AuthorizationsController < ApplicationController
  def confirm_email
    authorization = Authorization.find params[:id]
    authorization.update!(email: params[:email], confirmed_at: Time.now)
  end
end
