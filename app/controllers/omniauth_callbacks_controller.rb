class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def request_email
    @user = User.where(email: email_params[:body]).first
    @session = session['device.facebook_data']
    if @user
      @user.new_authorization(@session)
    else
      @user = User.both_user_and_authorization_create(email_params[:body], @session)
    end
  end

  def facebook
    auth = request.env['omniauth.auth']
    user = User.find_for_oauth(auth)
    if user
      check_for_is_authorization_confirmed?(user, auth)
    else
      session['device.facebook_data'] = auth
      render 'omniauth_callbacks/get_email'
    end
  end

  private

  def check_for_is_authorization_confirmed?(user, auth)
    if user.authorization_confirmed?(auth)
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'лицокнига') if is_navigational_format?
    else
      render 'omniauth_callbacks/resend_confirmation_email'
    end
  end

  def email_params
    params.require(:email).permit(:body)
  end
end
