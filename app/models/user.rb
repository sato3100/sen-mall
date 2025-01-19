class User < ApplicationRecord
  has_secure_password
  # カート
  has_one :cart, dependent: :destroy
  after_create :create_cart

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
  has_many :favorite_users_records, class_name: "FavoriteUser", foreign_key: "user_id", dependent: :destroy
  has_many :favorited_users, through: :favorite_users_records, source: :favorited_user

  # DM機能
  has_many :entries, dependent: :destroy
  has_many :rooms, through: :entries
  has_many :messages, dependent: :destroy

  private def create_cart
    Cart.create(user_id: self.id)
  end

    # バリデーション
    validates :family_name, presence: true, length: { maximum: 15 }
    validates :given_name,  presence: true, length: { maximum: 15 }
    validates :business_name, presence: true, length: { in: 2..15 }, uniqueness: true
    validates :email, presence: true, uniqueness: true, email: true
    validates :address, presence: true, length: { maximum: 50 }
    validates :phone_number, presence: true, length: { in: 8..20 },
                            format: { with: /\A[\d\-]+\z/ }
    validates :password, length: { in: 8..16 }, format: { with: /\A[!-~]+\z/, }, allow_nil: true
end
