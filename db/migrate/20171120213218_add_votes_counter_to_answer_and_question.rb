class AddVotesCounterToAnswerAndQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :votes_count, :integer, default: 0
    add_column :questions, :votes_count, :integer, default: 0
  end
end
