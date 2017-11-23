class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :subject, polymorphic: true

  validates :user, :subject, :value, presence: true
  validates :user, uniqueness: { scope: :subject_id }

  def update_value(vote_value)
    unless value == vote_value
      update(value: value + vote_value)
      update_subject_votes_count(vote_value)
    end
  end

  def update_subject_votes_count(vote_value)
    new_value = subject.votes_count + vote_value
    subject.update(votes_count: new_value)
  end
end
