class Message < ApplicationRecord
  belongs_to :user
  belongs_to :item
  belongs_to :room
end
