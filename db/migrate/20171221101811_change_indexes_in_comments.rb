class ChangeIndexesInComments < ActiveRecord::Migration[5.1]
  def change
    remove_index :comments, :commented_id
    add_index :comments, [:commented_id, :commented_type]
  end
end
