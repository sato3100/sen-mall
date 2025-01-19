class CartsController < ApplicationController
  before_action :login_required

  def add
    # カートに追加する商品
    item = Item.find(params[:item_id])
    unless item
      redirect_to items_path, alert: "商品が見つかりません。" and return
    end

    @cart = current_user.cart || Cart.create(user: current_user)
    @cart.cart_items.create(item: item, quantity: params[:quantity])

    redirect_to cart_path, notice: '商品をカートに追加しました。'
  end

  def show
    @cart = current_user.cart || Cart.create(user: current_user)
    @items = @cart.items
  end
end
