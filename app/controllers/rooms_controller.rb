class RoomsController < ApplicationController
  def index
    @room_make_form = RoomMakeForm.new(flash[new_room_path]&.dig('params'))
    @errors = flash[new_room_path]&.dig('errors') || []
  end

  def create
    binding.pry
    @room_make_form = RoomMakeForm.new(room_make_params)
    unless @room_make_form.save
      flash[new_room_path] = {
        params: room_make_params,
        errors: @room_make_form.errors.full_messages
      }
      redirect_to root_path and return
    end
    redirect_to room_path(@room_make_form.room)
  end

  def show
    render json: {msg: 'hello'}
  end

  private

  def room_make_params
    params.require(:room_make_form)
          .permit(:title, :is_private, :name)
  end
end
