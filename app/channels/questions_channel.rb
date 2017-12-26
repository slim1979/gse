class QuestionsChannel < ApplicationCable::Channel
  def follow
    stream_from 'questions'
  end

  def question_update(data)
    stream_from "questions/#{data['id']}/question_update"
  end

  def unfollow
    stop_all_streams
  end
end
