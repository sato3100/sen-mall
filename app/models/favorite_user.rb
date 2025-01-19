class FavoriteUser < ApplicationRecord
  belongs_to :user
  belongs_to :favorited_user, class_name: "User"

    validate :user_cannot_favorite_self

    private def user_cannot_favorite_self
      if user_id == favorited_user_id
        errors.add(:favorited_user_id, '自分をお気に入り登録はできません。')
      end
    end
end
