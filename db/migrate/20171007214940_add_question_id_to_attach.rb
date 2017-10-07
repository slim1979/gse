class AddQuestionIdToAttach < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :attaches, :question
  end
end
