class Attach < ApplicationRecord
  belongs_to :question

  mount_uploader :file, FileUploader
end
