class ChangeCommentsIndexes < ActiveRecord::Migration[5.1]
  def change
    remove_index :comments, :commentable_id
    add_index    :comments, [:commentable_id, :commentable_type]
  end
end
