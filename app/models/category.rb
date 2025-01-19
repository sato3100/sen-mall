class Category < ApplicationRecord
  has_many :items, dependent: :nullify

  validates :category_name, presence: true, length: { maximum: 20 }
end
