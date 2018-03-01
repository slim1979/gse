class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :commented_id, :body, :commented_type, :created_at, :updated_at
end
