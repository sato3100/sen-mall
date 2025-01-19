class Seller::ItemsController < ApplicationController
  before_action :login_required
  before_action :require_seller

  def index
    @items = current_user.items
    .page(params[:page]).per(10)
  end

  def new
    @item = current_user.items.build
    @categories = Category.all
  end

  def create
    raw_item = params[:item] || {}
    @item = current_user.items.build(raw_item)
    @item.user_id = current_user.id
    @item.new = (raw_item[:new] == "1")

    if @item.save
      redirect_to seller_items_path, notice: "商品を登録しました"
    else
      flash[:alert] = @item.errors.full_messages
      @categories = Category.all
      render :new
    end
  end

  def edit
    @item = current_user.items.find(params[:id])
    @categories = Category.all
  end

  def update
    @item = current_user.items.find(params[:id])
    @item.new = params[:item][:new] == "1"

    if @item.update(params[:item])
      redirect_to seller_items_path, notice: "商品を更新しました"
    else
      flash[:alert] = @item.errors.full_messages
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    @item = current_user.items.find(params[:id])
    if @item.order_items.exists?
      redirect_to seller_items_path, alert: "この商品は購入履歴があるため削除できません。在庫を0にして非公開扱いにしてください。"
      return
    end

    if @item.cart_items.exists? || @item.favorite_items.exists?
      redirect_to seller_items_path, alert: "この商品はカートやお気に入りに残っているため削除できません..."
      return
    end

    @item.destroy
    redirect_to seller_items_path, notice: "出品を取り消しました"
  end

  private def require_seller
    unless current_user&.status == 2
      redirect_to root_path, alert: "出品者権限がありません"
    end
  end
end
