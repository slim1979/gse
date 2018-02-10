class Authorization < ApplicationRecord
  belongs_to :user

  validates :uid, uniqueness: true


  def self.confirm_me_with(id, email)
    authorization = Authorization.find id
    user = authorization.user
    user.update!(confirmed_at: Time.now)
    authorization.update!(email: email, confirmed_at: Time.now)
    authorization
  end
end
