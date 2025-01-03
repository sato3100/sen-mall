class User < ApplicationRecord
  has_secure_password
  # カート
  has_one :cart, dependent: :destroy

  # 注文
  has_many :orders, dependent: :destroy

  # レビュー
  has_many :reviews, dependent: :destroy

  # 出品者に紐付いている商品
  has_many :items, foreign_key: :user_id, dependent: :destroy

  # お気に入りの商品
  has_many :favorite_items, dependent: :destroy
  has_many :favorited_items, through: :favorite_items, source: :item

  # お気に入りのユーザ（出品者をいいね）
  has_many :favorite_users_records, class_name: "FavoriteUser", dependent: :destroy
  has_many :favorited_users, through: :favorite_users_records, source: :favorite_user

  # DM機能
  has_many :entries, dependent: :destroy
  has_many :rooms, through: :entries
  has_many :messages, dependent: :destroy
end
