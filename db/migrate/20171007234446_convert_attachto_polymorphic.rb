class ConvertAttachtoPolymorphic < ActiveRecord::Migration[5.1]
  def change
    remove_belongs_to :attaches, :question
    add_belongs_to :attaches, :attachable
    add_column :attaches, :attachable_type, :string
    remove_index :attaches, :attachable_id
    add_index :attaches, [:attachable_id, :attachable_type]
  end
end
