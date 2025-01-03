class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :reviews, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :messages, dependent: :destroy  # 問い合わせで、item_idがある場合

  # favorite_items
  has_many :favorite_items
  has_many :favorited_by_users, through: :favorite_items, source: :user
end
