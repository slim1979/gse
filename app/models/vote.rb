class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :subject, polymorphic: true

  validates :user, :subject, :value, presence: true
  validates :user, uniqueness: { scope: :subject_id }

end
