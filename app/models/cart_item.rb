class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item, class_name: "Item", foreign_key: "item_id"

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
end
