class User < ApplicationRecord
  belogs_to :room
  has_many :messages
end
