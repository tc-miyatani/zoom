class User < ApplicationRecord
  belogs_to :room
  has_many :messages, dependent: :destroy

  validates :name,  presence: true,
                    uniqueness: {
                      scope: :room_id,
                      message: '同じ部屋に同じユーザー名の人が入室中です'
                    }

end
