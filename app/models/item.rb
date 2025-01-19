class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :reviews, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :messages

  # 価格フィルタの
  scope :price_gte, ->(min){ where("price >= ?", min) if min.present? }
  scope :price_lte, ->(max){ where("price <= ?", max) if max.present? }
  scope :by_category, ->(cat){ joins(:category).where(categories: { category_name: cat }) if cat.present? }

  # favorite_items
  has_many :favorite_items
  has_many :favorited_by_users, through: :favorite_items, source: :user

  # ActiveStorage
  has_one_attached :image_item
  attribute :item_picture
  attribute :remove_picture, :boolean

  # バリデーション
  validates :category_id, presence: true
  validates :name,  presence: true, length: { maximum: 50 }
  validates :code,  presence: true, length: { maximum: 30 }
  validates :price, presence: true,
                    numericality: {
                      only_integer: true,
                      greater_than: 0,
                      less_than_or_equal_to: 100_000_000
                    }
  validates :stock, presence: true,
                    numericality: {
                      only_integer: true,
                      greater_than_or_equal_to: 0,
                      less_than_or_equal_to: 99
                    }
  validates :description, length: { maximum: 500 }


  # 画像のアップロード
  before_save do
    if item_picture
      self.image_item = item_picture
    elsif remove_picture
      self.image_item.purge
    end
  end
end
