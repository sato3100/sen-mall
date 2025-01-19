class CartsController < ApplicationController
  before_action :login_required

  def add
    # ログインユーザのカートを取得、存在しなければユーザ用カートを生成
    @cart = current_user.cart || Cart.create(user: current_user)

    # カートに追加する商品
    product = Item.find(params[:item_id])

    # 既にカートに商品がある場合は数量の追加
    if cart_item = @cart.cart_items.find_by(item: item)
      cart_item.increment!(quantity: params[:quantity])
    else
      @cart.cart_items.create(item: item, quantity: params[:quantity])
    end

    redirect_to cart_path, notice: '商品をカートに追加しました。'
  end

  def show
    @cart = current_user.cart || Cart.create(user: current_user)
    @items = @cart.items
  end
end
