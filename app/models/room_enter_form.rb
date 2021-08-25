class RoomEnterForm
  include ActiveModel::Model
  attr_accessor :room_hashid, :name, :room, :user

  with_options presence: true do
    validates :room_hashid
    validates :name
  end

  def save
    unless self.valid?
      return false
    end
    self.room = Room.find_by(hashid: room_hashid)
    self.user = self.room.users.new(name: name)
    self.user.save
  end
end
