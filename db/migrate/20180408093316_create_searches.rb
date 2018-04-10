class CreateSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :searches do |t|
      t.string  :search_for
      t.integer :search_through

      t.timestamps
    end
  end
end
