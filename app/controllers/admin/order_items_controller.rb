class Admin::OrderItemsController < ApplicationController
  before_action :require_admin

  def update
    @order_item = OrderItem.find(params[:id])

    new_delivery = params.dig(:order_item, :delivery)
    if @order_item.update(delivery: new_delivery)
      redirect_to admin_orders_path, notice: "配送状況を「#{@order_item.delivery_text}」に変更しました。"
    else
      flash[:alert] = @order_item.errors.full_messages
      redirect_back fallback_location: admin_orders_path
    end
  end
end
