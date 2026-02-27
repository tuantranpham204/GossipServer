class MessageChannel < ApplicationCable::Channel
  def subscribed
    room_id = params[:room_id]
    stream_from "Room_#{room_id}"
  end

  def unsubscribed
    stop_all_streams
  end
end