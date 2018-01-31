FactoryBot.define do
  sequence :email do |n|
    "new#{n}@test_email.com"
  end

  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'
    confirmation_sent_at Time.now
    confirmed_at Time.now
  end
end
