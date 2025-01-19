class Entry < ApplicationRecord
  belongs_to :room
  belongs_to :user, optional: true
  belongs_to :admin, optional: true
end
