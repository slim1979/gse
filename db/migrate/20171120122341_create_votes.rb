class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.belongs_to :user
      t.belongs_to :subject
      t.string :subject_type
      t.integer :value

      t.timestamps
    end
  end
end
