class Message < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :room, optional: true
  belongs_to :admin, optional: true

  # バリデーション
  validates :message, presence: true,
                    length: { maximum: 500,
                            too_long: "は500文字以内で入力してください" }
end
