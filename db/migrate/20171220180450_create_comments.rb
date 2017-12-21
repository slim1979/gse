class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.belongs_to :user
      t.belongs_to :commented
      t.string     :body
      t.string     :commented_type

      t.timestamps
    end
  end
end
