class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "questions/#{data['id']}/answers"
  end

  def unfollow
    stop_all_streams
  end
end
