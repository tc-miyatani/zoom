class MessagesController < ApplicationController
  def create
    room_hashid = params[:room_hashid]
    room = Room.find_by(hashid: room_hashid)
    message = room.messages.new(message_params)
    if message.save
      data = message.to_json(include: {
                              user: { only: [:id, :name] },
                            })
      ActionCable.server.broadcast "room_#{room_hashid}", data: data
      render json: { is_success: true }
    else
      render json: { is_success: false }
    end
  end

  private

  def message_params
    params.require(:message)
          .permit(:content)
          .merge(user_id: session['user_id'])
  end
end
