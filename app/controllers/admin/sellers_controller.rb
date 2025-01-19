class Admin::SellersController < ApplicationController
  before_action :require_admin

  def index
    # 出品者(status=2)だけ一覧
    @sellers = User.where(status: 2).order(:id)
  end

  def show
    @seller = User.find(params[:id])
    redirect_to admin_sellers_path, alert: "出品者ではありません" if @seller.status != 2
    # もし購入者だったら表示させない
  end

  def edit
    @seller = User.find(params[:id])
    redirect_to admin_sellers_path, alert: "出品者ではありません" if @seller.status != 2
  end

  def update
    @seller = User.find(params[:id])
    if @seller.update(params[:user])
      redirect_to admin_seller_path(@seller), notice: "出品者情報を更新しました。"
    else
      flash[:alert] = @seller.errors.full_messages
      render :edit
    end
  end

  def destroy
    @seller = User.find(params[:id])
    if @seller.status != 2
      redirect_to admin_sellers_path, alert: "出品者ではありません"
      return
    end

    # 配送中の商品があるかどうか
    if cannot_delete_seller?(@seller)
      redirect_to admin_sellers_path, alert: "配送中の商品があるため削除できません。"
      return
    end

    @seller.destroy
    redirect_to admin_sellers_path, notice: "出品者を削除しました。"
  end

  private def cannot_delete_seller?(seller)
    item_ids = seller.items.pluck(:id)
    OrderItem.where(item_id: item_ids, delivery: [1,2,3]).exists?
  end
end
