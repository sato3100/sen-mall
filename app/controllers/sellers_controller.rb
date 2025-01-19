class SellersController < ApplicationController
  # 出品者トップを表示（ログイン直後にここへ来る想定）
  def top
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.status = 2  # 出品者フラグ

    fn = params[:user][:family_name]
    gn = params[:user][:given_name]
    @user.full_name = "#{fn} #{gn}"

    if @user.save
      cookies.signed[:user_id] = { value: @user.id, expires: 24.hours.from_now }
      redirect_to seller_top_path, notice: "出品者として登録しました"
    else
      flash[:alert] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @seller = User.find(params[:id])
    unless @seller.status == 2
      redirect_to root_path, alert: "出品者が見つかりません"
      return
    end
    @items = @seller.items.page(params[:page]).per(20)
  end

  def update
    @user = User.find(params[:id])
    fn = params[:user][:family_name]
    gn = params[:user][:given_name]
    @user.assign_attributes(params[:user])
    @user.full_name = "#{fn} #{gn}"

    if @user.save
      redirect_to seller_path(@user), notice: "出品者情報を更新しました"
    else
      flash[:alert] = @user.errors.full_messages
      render :edit
    end
  end
end
