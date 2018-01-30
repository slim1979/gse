class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  has_many :authorizations, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def author_of?(resource)
    resource.user_id == id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    authorization.user if authorization
  end

  def self.both_user_and_authorization_create(email, auth)
    password = Devise.friendly_token[0, 20]
    user = User.create(email: email, password: password, password_confirmation: password)
    user.new_autorization(auth)
    user
  end

  def new_authorization(auth)
    new_authorization = self.authorizations.create(provider: auth['provider'], uid: auth['uid'])
    send_confirmation_email(self, new_authorization)
  end

  def authorization_confirmed?(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    authorization.email if authorization
  end

  private

  def send_confirmation_email(user, authorization)
    AuthorizationMailer.confirm_email(user, authorization.id).deliver_now
  end
end
