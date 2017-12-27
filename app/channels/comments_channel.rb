class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "questions/#{data['id']}/comments"
  end

  def unfollow
    stop_all_streams
  end
end
