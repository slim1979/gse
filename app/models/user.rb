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
    return authorization.user if authorization

    # new_autorization(auth)
  end

  def self.new_autorization(auth)
    password = Devise.friendly_token[0, 20]
    email = [Devise.friendly_token[0, 8], '@temporary_mail.ru'].join
    user = User.create(email: email, password: password, password_confirmation: password)
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end
end
