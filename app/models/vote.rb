class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :subject, polymorphic: true
end
