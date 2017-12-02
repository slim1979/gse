class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :subject, polymorphic: true

  validates :user, :subject, :value, presence: true
  validates_uniqueness_of :user_id, scope: %i[subject_id subject_type]
end
