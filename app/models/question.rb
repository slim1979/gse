class Question < ApplicationRecord
  include VotesActions

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attaches, as: :attachable, dependent: :destroy
  has_many :votes, as: :subject, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attaches, reject_if: proc { |attrib| attrib['file'].nil? }
end
