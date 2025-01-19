class OrderItem < ApplicationRecord
  belongs_to :item
  belongs_to :order

  # 配送ステータス
  DELIVERY_STATUSES = {
    0 => "未配送",
    1 => "配送中",
    2 => "配送完了",
    3 => "返品中",
    4 => "返品完了",
    5 => "キャンセル"
  }

  def delivery_text
    DELIVERY_STATUSES[self.delivery] || "不明"
  end
  # バリデーション
  validate :only_next_delivery

  private def only_next_delivery
    return unless delivery_changed? && delivery_was.present?

    old_deliv = delivery_was
    new_deliv = delivery

    allowed = [old_deliv + 1, 5]
    unless allowed.include?(new_deliv)
      errors.add(:delivery, "は現在の状態から連続するステータスのみ変更できます (#{DELIVERY_STATUSES[old_deliv]}→#{DELIVERY_STATUSES[new_deliv]}は不可)")
    end
  end
end
