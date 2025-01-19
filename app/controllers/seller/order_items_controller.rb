class Seller::OrderItemsController < ApplicationController
  before_action :login_required

  def update
    @order = Order.find(params[:order_id])
    @order_item = @order.order_items.find(params[:id])

    new_delivery_val = params.dig(:order_item, :delivery).to_i
    @order_item.delivery = new_delivery_val

    if @order_item.save
      redirect_to seller_orders_path, notice: "配送状況を「#{@order_item.delivery_text}」に変更しました"
    else
      flash[:alert] = @order_item.errors.full_messages
      redirect_back fallback_location: seller_orders_path
    end
  end
end
