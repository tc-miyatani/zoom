class MessageChannel < ApplicationCable::Channel
  def subscribed
    # ここのparamsは`message_channel.js`の`consumer.subscriptions.create`の第1引数から与えられる
    # room = Room.find(params[:room_hashid])
    # stream_from room
    stream_from "room_#{params[:room_hashid]}" # room毎にチャンネルを分ける
  end

  def unsubscribed
    current_user.update(is_enter: false) # TODO: ユーザーの入室中フラグをfalseにする
    # ルームに入室中のユーザーが０人になったらルームを削除
    # room_users_count = User.joins(:room).where(rooms: {hashid: params[:room_hashid]}, is_enter: true).count
    # room = Room.find_by(hashid: params[:room_hashid])
    # room_users_count = room.users.where(is_enter:true).count
    # if room_users_count == 0
    #   room.destroy
    # end
  end

  private

  def current_user
    User.find(session['user_id'])
  end

  # connectionを経由しないとsessionが取ってこれない為
  def session
    session_key_name = Rails.application.config.session_options[:key]
    connection.send(:cookies)
              .encrypted[session_key_name]
              &.with_indifferent_access
  end
end
