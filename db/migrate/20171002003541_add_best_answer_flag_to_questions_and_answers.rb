class AddBestAnswerFlagToQuestionsAndAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :best_answer, :integer
    add_column :answers, :best_answer, :boolean, default: false
  end
end
