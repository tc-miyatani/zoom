require "securerandom"
class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users,    dependent: :destroy

  with_options presence: true do
    validates :title
    validates :hashid, uniqueness: true
  end
  validates :is_private, inclusion: [true, false]

  # 使われていないroomの自動削除
  #   入室中のユーザーが居ない or 最後に居たユーザーが退室してから5分以上経過 で削除
  def self.delete_not_used_rooms
    # destroy_allはN+1回分のSQLが発行されるので、手動で依存する順番にdelete_allする
    rooms = Room.where(%|
      NOT EXISTS (SELECT 1 FROM users u WHERE u.room_id=rooms.id AND u.is_enter=1)
      AND
      NOT EXISTS (SELECT 1 FROM users u WHERE u.room_id=rooms.id AND u.is_enter=0
        AND u.updated_at > (NOW() - INTERVAL 5 MINUTE)
      )
    |)
    if rooms.exists?
      Message.where(room_id: rooms.pluck(:id)).delete_all
      User.where(room_id: rooms.pluck(:id)).delete_all
      rooms.delete_all
    end
  end
end
