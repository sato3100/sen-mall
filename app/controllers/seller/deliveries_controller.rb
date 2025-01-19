class Seller::DeliveriesController < ApplicationController
  before_action :login_required

  def index
    @orders = Order.includes(:order_items).where(order_items: { item_id: current_user.items })
  end

  def show
    @order = Order.find(params[:id])
  end
end
