require "securerandom"
class Room < ApplicationRecord
  has_many :users, dependent: :destroy

  with_options presence: true do
    validates :title
    validates :hashid, uniqueness: true
  end
  validates :is_private, inclusion: [true, false]

  def save
    generate_hashid
    super
  end

  private

  def generate_hashid
    self.hashid = SecureRandom.urlsafe_base64
  end
end
