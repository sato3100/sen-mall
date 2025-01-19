class Admin < ApplicationRecord
  has_secure_password

  validates :family_name, presence: true, length: { maximum: 15 }
  validates :given_name,  presence: true, length: { maximum: 15 }
  validates :email, presence: true, uniqueness: true, email: true
  validates :address, presence: true, length: { maximum: 50 }
  validates :phone_number, presence: true, length: { in: 8..20 },
                              format: { with: /\A[\d\-]+\z/ }
  validates :password, length: { in: 8..16 }, format: { with: /\A[!-~]+\z/, }, allow_nil: true
end
