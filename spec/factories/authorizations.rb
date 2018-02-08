FactoryBot.define do
  factory :authorization do
    provider "default"
    uid "1234"
    confirmed_at Time.now
  end
end
