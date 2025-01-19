class Seller::OrdersController < ApplicationController
  before_action :login_required
  before_action :require_seller

  def index
    seller_item_ids = current_user.items.ids
    @orders = Order.joins(:order_items).where(order_items: { item_id: seller_item_ids }).distinct
  end

  def edit
    @order = Order.find(params[:id])
    seller_item_ids = current_user.items.ids
    @order_items = @order.order_items.where(item_id: seller_item_ids)
  end

  private def require_seller
    unless current_user && current_user.status == 2
      redirect_to root_path, alert: "出品者権限がありません"
    end
  end
end
