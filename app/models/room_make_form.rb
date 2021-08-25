class RoomMakeForm
  include ActiveModel::Model
  attr_accessor :title, :is_private, :name, :room, :user

  with_options presence: true do
    validates :title
    validates :name
  end
  validates :is_private, inclusion: ['1', '0']

  def save
    unless self.valid?
      return false
    end
    is_success = false
    ActiveRecord::Base.transaction(joinable: false, requires_new: true) do
      self.room = Room.create!(
        title: title,
        is_private: is_private,
        hashid: generate_hashid
      )
      self.user = self.room.users.create!(name: name)
      is_success = true
    end
    is_success
  end

  private

  def generate_hashid
    SecureRandom.urlsafe_base64
  end
end
