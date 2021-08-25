class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'message_channel'
  end

  def unsubscribed
    # TODO: ユーザーの入室中フラグをfalseにする
    # TODO: ルームに入室中のユーザーが０人になったらルームの削除
  end
end
