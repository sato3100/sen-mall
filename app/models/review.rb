class Review < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :rating,
  presence: { message: "を入力してください" },
  numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
    allow_blank: true,
    message: "は1〜5の数値で入力してください"
  }
  validates :content, length: { maximum: 200 }
end
