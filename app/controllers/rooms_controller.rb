class RoomsController < ApplicationController
  def index
    unless session['user_id'].nil?
      User.find(session['user_id']).update(is_enter: false)
      session['user_id'] = nil
    end
    @room_make_form = RoomMakeForm.new(flash[new_room_path]&.dig('room_make_params'))
    @room_enter_form = RoomEnterForm.new(flash[new_room_path]&.dig('room_enter_params'))
    @errors = flash[new_room_path]&.dig('errors') || []
    Room.delete_not_used_rooms
    @rooms = Room.includes(:users).where(is_private: false).order(created_at: 'DESC')
  end

  def enter
    room_enter_form = RoomEnterForm.new(room_enter_params)
    unless room_enter_form.save
      flash[new_room_path] = {
        room_enter_params: room_enter_params,
        errors: room_enter_form.errors.full_messages
      }
      redirect_to root_path and return
    end
    session['user_id'] = room_enter_form.user.id
    redirect_to room_path(room_enter_form.room.hashid)
  end

  def create
    room_make_form = RoomMakeForm.new(room_make_params)
    unless room_make_form.save
      flash[new_room_path] = {
        room_make_params: room_make_params,
        errors: room_make_form.errors.full_messages
      }
      redirect_to root_path and return
    end
    session['user_id'] = room_make_form.user.id
    redirect_to room_path(room_make_form.room.hashid)
  end

  def show
    if session['user_id'].blank?
      redirect_to root_path and return
    end
    @room = Room.find_by(hashid: params[:hashid])
    if @room.blank?
      redirect_to root_path and return
    end
    @messages = @room.messages.includes(:user).order(created_at: 'DESC')
    @message = @messages.new
    @user = User.find(session['user_id'])
  end

  private

  def room_make_params
    params.require(:room_make_form)
          .permit(:title, :is_private, :name)
  end

  def room_enter_params
    params.require(:room_enter_form)
          .permit(:room_hashid, :name)
  end
end
