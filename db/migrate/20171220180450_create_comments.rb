class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string     :body
      t.string     :commentable_type
      t.belongs_to :commentable

      t.timestamps
    end
  end
end
