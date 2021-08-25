class MessageChannel < ApplicationCable::Channel
  def subscribed
    # ここのparamsは`message_channel.js`の`consumer.subscriptions.create`の第1引数から与えられる
    # room = Room.find(params[:room_hashid])
    # stream_from room
    stream_from "room_#{params[:room_hashid]}" # room毎にチャンネルを分ける
  end

  def unsubscribed
    # TODO: ユーザーの入室中フラグをfalseにする
    # TODO: ルームに入室中のユーザーが０人になったらルームの削除
  end
end
