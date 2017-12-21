class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commented, polymorphic: true

  validates :body, :user, presence: true

  after_create :publish_comment

  private

  def publish_comment
    return if errors.any?
    ActionCable.server.broadcast(
      'comments',
      ApplicationController.render(
        partial: 'comments/new_comment',
        locals: { comment: self }
      )
    )
  end
end
