class FavoritesController < ApplicationController
  before_action :set_user

  def index
    @favorite_items = @user.favorite_items.includes(:item)
    @favorite_users_records = @user.favorite_users_records.includes(:favorited_user)
  end

  def create
    if params[:favorite_item_id]
      item_id = params[:favorite_item_id]
      # 既にお気に入り済みかチェック
      existing = @user.favorite_items.find_by(item_id: item_id)
      if existing
        redirect_to user_favorites_path(@user),
          alert: "すでにお気に入り登録されています。"
        return
      end

      @favorite_item = @user.favorite_items.build(item_id: item_id)
      if @favorite_item.save
        redirect_to user_favorites_path(@user), notice: 'お気に入り商品を追加しました。'
      else
        redirect_to user_favorites_path(@user), alert: 'お気に入り商品を追加できませんでした。'
      end

    elsif params[:favorite_user_id]
      seller_id = params[:favorite_user_id]
      existing = @user.favorite_users_records.find_by(favorited_user_id: seller_id)
      if existing
        redirect_to user_favorites_path(@user),
          alert: "すでにお気に入りの出品者です。"
        return
      end

      @favorite_user = @user.favorite_users_records.build(favorited_user_id: seller_id)
      if @favorite_user.save
        redirect_to user_favorites_path(@user), notice: 'お気に入り出品者を追加しました。'
      else
        Rails.logger.debug("==== FavoriteUser error: #{@favorite_user.errors.full_messages}")
        redirect_to user_favorites_path(@user), alert: 'お気に入り出品者を追加できませんでした。'
      end

    else
      redirect_to user_favorites_path(@user), alert: '追加するお気に入りが指定されていません。'
    end
  end

  def destroy
    fav_item = FavoriteItem.find_by(id: params[:id])
    if fav_item
      fav_item.destroy
      redirect_to user_favorites_path(@user), notice: 'お気に入り商品を削除しました。'
      return
    end

    fav_user = FavoriteUser.find_by(id: params[:id])
    if fav_user
      fav_user.destroy
      redirect_to user_favorites_path(@user), notice: 'お気に入り出品者を削除しました。'
      return
    end

    redirect_to user_favorites_path(@user), alert: '対象のお気に入りが見つかりませんでした。'
  end

  private def set_user
    @user = User.find(params[:user_id])
  end
end
