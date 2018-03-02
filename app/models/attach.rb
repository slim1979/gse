class Attach < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true

  mount_uploader :file, FileUploader

  default_scope { order(id: 'ASC') }

  validates :file, presence: true

  after_destroy_commit :destroy_attaches

  private

  def destroy_attaches
    return if errors.any?
    ActionCable.server.broadcast(
      'attaches',
      ApplicationController.render(
        json: { destroy: { id: id } }
      )
    )
  end
end
