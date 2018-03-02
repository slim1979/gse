class AnswerWithAttrSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :created_at, :updated_at, :user_id, :best_answer, :votes_count

  has_many :comments
  has_many :attaches
end
