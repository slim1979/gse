class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authorize_me_with_social_network
  end

  def twitter
    authorize_me_with_social_network
  end

  def request_email
    authorization_with(session['devise.omniauth_data'], email_params[:address])
  end

  private

  def authorize_me_with_social_network
    auth = session['devise.omniauth_data'] = request.env['omniauth.auth'].except('extra')
    email = auth['info']['email']
    authorization_with(auth, email)
  end

  def authorization_with(auth, email)
    user = User.find_for_oauth(auth, email)
    if user
      check_for_is_authorization_confirmed?(auth, user)
    else
      ask_for_email(auth)
    end
  end

  def ask_for_email(auth)
    render 'omniauth_callbacks/get_email', locals: { social: auth['provider'].capitalize }
  end

  def check_for_is_authorization_confirmed?(auth, user)
    if user.authorization_confirmed?(auth)
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: auth['provider'].capitalize) if is_navigational_format?
    else
      user.first_or_create_authorization(auth)
      render 'omniauth_callbacks/resend_confirmation_email', locals: { email: user.email }
    end
  end

  def email_params
    params.require(:email).permit(:address)
  end
end
