class Admin::OrdersController < ApplicationController
  before_action :require_admin

  def index
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @orders = @user.orders.includes(:order_items).order(id: :desc)
    else
      # 全注文一覧
      @orders = Order.includes(:order_items).order(id: :desc)
    end

    @orders = @orders.page(params[:page]).per(30)
  end

  def show
    @order = Order.find(params[:id])
  end

  def edit
    @order = Order.find(params[:id])
    deliveries = @order.order_items.pluck(:delivery).uniq
    @unique_delivery = deliveries.size == 1 ? deliveries.first : nil
  end

  def update
    @order = Order.find(params[:id])
    new_delivery = params[:new_delivery].to_i
    if @order.order_items.update_all(delivery: new_delivery)
      changed_status_name = OrderItem::DELIVERY_STATUSES[new_delivery]
      redirect_to admin_orders_path, notice: "配送状況を「#{changed_status_name}」に更新しました"
    else
      flash[:alert] = @order.errors.full_messages
      render :edit
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to admin_orders_path, notice: "注文データを削除しました。"
  end
end
