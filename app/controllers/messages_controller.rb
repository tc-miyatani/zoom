class MessagesController < ApplicationController
  def create
    room = Room.find(params[:room_hashid])
    message = room.messages.new(message_params)
    if message.save
      ActionCable.server.broadcast 'message_channel',
        data: message.to_json(include: {
                                user: { only: [:id, :name] },
                              })
    end
  end

  private

  def message_params
    params.require(:message)
          .permit(:content)
          .merge(user_id: session['user_id'])
  end
end
