class CreateAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :authorizations do |t|
      t.references :user, foreign_key: true, index: true
      t.string :provider
      t.string :uid
      t.string :email
      t.string :confirmed_at, default: nil

      t.timestamps
    end
  end
end
