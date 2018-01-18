class AttachesChannel < ApplicationCable::Channel
  def follow
    stream_from 'attaches'
  end

  def unfollow
    stop_all_streams
  end
end
