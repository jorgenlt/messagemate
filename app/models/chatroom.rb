class Chatroom < ApplicationRecord
  belongs_to :user
  has_many :messages

  validates :username, presence: true
end
