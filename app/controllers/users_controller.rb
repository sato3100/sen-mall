class UsersController < ApplicationController
  # マイページ
  def show
    @user = User.find(params[:id])
    return if @user == current_user

    current_entries = current_user.entries
    another_entries = @user.entries

    # 既存のルームがあるかチェック
    @is_room = false
    current_entries.each do |ce|
      another_entries.each do |ae|
        if ce.room_id == ae.room_id
          @is_room = true
          @room_id = ce.room_id
        end
      end
    end

    # ルームが無ければ新規作成用の変数準備
    unless @is_room
      @room  = Room.new
      @entry = Entry.new
    end
  end

  # ユーザー情報の編集
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(params[:user])
      @user.update(full_name: "#{@user.family_name} #{@user.given_name}")
      redirect_to user_path(@user), notice: "出品者情報を編集しました"
    else
      flash[:alert] = @user.errors.full_messages
      render :edit
    end
  end

  # ユーザーの削除
  def destroy
    @user = User.find(params[:id])
    if @user != current_user && !current_user_is_admin?
      redirect_to root_path, alert: "権限がありません。"
      return
    end

    # 購入中チェック
    if cannot_delete_account?(@user)
      flash[:alert] = "購入中の商品があるため、アカウントを削除できません。"
      redirect_to user_path(@user)
      return
    end

    @user.destroy
    # 自分自身を削除
    cookies.delete(:user_id) if @user == current_user
    redirect_to root_path, notice: "アカウントを削除しました"
  end

  # ユーザー検索結果画面
  def search
    form_params = params[:user_search] || {}
    @keyword    = form_params[:q]
    base        = User.where(status: 2)

    if @keyword.present?
      base = base.where("business_name LIKE ?", "%#{@keyword}%")
    end

    @users = base
  end

  private def cannot_delete_account?(user)
    if user.status == 1
      # 購入者
      user.orders.joins(:order_items).where(order_items: { delivery: [0,1,2,3] }).exists?
    elsif user.status == 2
      # 出品者
      item_ids = user.items.ids
      OrderItem.where(item_id: item_ids, delivery: [0,1,2,3]).exists?
    else
      false
    end
  end
end
