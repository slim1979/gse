class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook twitter]
  has_many :authorizations, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def self.send_daily_digest
  end

  def author_of?(resource)
    resource.user_id == id
  end

  def self.find_for_oauth(auth, email)
    authorization = Authorization.where(provider: auth['provider'], uid: auth['uid']).first
    return authorization.user if authorization

    user = User.where(email: email).first
    if user
      user.first_or_create_authorization(auth)
    else
      User.both_user_and_authorization_create(auth, email) if email
    end
  end

  def self.both_user_and_authorization_create(auth, email)
    password = Devise.friendly_token[0, 20]
    user = User.new(email: email, password: password, password_confirmation: password)
    user.skip_confirmation_notification!
    user.save!
    user.first_or_create_authorization(auth)
  end

  def first_or_create_authorization(auth)
    authorizations.where(provider: auth['provider'], uid: auth['uid']).first_or_create
    self
  end

  def current_authorization(auth)
    authorizations.where(provider: auth['provider'], uid: auth['uid']).first
  end

  def send_confirmation_email(user, authorization)
    AuthorizationMailer.confirm_email(user, authorization.id).deliver_now
  end
end
