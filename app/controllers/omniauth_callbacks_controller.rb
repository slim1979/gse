class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def request_email
    email = email_params[:address]
    this_session_data = session["device.#{social_network}_data"]
    email_received(this_session_data, email)
    redirect_to new_user_session_path
  end

  def facebook
    auth_data = session['device.facebook_data'] = request.env['omniauth.auth']
    email = request.env['omniauth.auth']['info']['email']
    email_received(auth_data, email) if email
    email_missed unless email
  end

  private

  def email_received(auth, email)
    user = User.where(email: email).first
    authorization?(auth, user) if user
    User.both_user_and_authorization_create(email, auth)
  end

  def email_missed
    auth = session["device.#{social_network}_data"]
    user = User.find_for_oauth(auth)
    if user
      check_for_is_authorization_confirmed?(user, auth)
    else
      ask_for_email
    end
  end

  def ask_for_email
    render 'omniauth_callbacks/get_email', locals: { social: social_network }
  end

  def authorization?(auth, user)
    authorization = user.authorizations.where(provider: auth.provider, uid: auth.uid)
    check_for_is_authorization_confirmed?(user, authorization) if authorization
    user.first_or_create_authorization(session["device.#{social_network}_data"]) unless authorization
  end

  def check_for_is_authorization_confirmed?(user, auth)
    if user.authorization_confirmed?(auth)
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'лицокнига') if is_navigational_format?
    else
      render 'omniauth_callbacks/resend_confirmation_email'
    end
  end

  def social_network
    ['facebook', 'twitter'].detect { |social| session["device.#{social}_data"]}
  end

  def email_params
    params.require(:email).permit(:address)
  end
end
