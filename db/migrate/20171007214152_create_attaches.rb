class CreateAttaches < ActiveRecord::Migration[5.1]
  def change
    create_table :attaches do |t|
      t.string :file

      t.timestamps
    end
  end
end
