class OrdersController < ApplicationController
  before_action :login_required

  # 注文履歴一覧
  def index
    @orders = current_user.orders.includes(order_items: :item)
  end

  # 注文詳細
  def show
    @order = current_user.orders.find_by(id: params[:id])
    @order_items = @order.order_items.includes(:item)
  end

  # 注文確認画面
  def confirm
    @order = current_user.orders.find_by(id: params[:id])
    @cart = current_user.cart
    if @cart.nil? || @cart.cart_items.empty?
      redirect_to cart_path, alert: "カートが空です。"
      return
    end
    @total_price = total_price(@cart)
  end

  # 注文確定
  def create
    cart = current_user.cart
    if cart.nil? || cart.cart_items.empty?
      redirect_to cart_path, alert: "カートが空です。" and return
    end

    # カート内のアイテムの在庫を再チェックする!
    cart.cart_items.each do |ci|
      # 在庫不足が見つかったら、注文を中断する
      if ci.quantity > ci.item.stock
        redirect_to cart_path, alert: "在庫が足りない商品があり、注文できませんでした。" and return
      end
    end

    cart.cart_items.each do |ci|
      if ci.price != ci.item.price
        # 価格が変更されたら注文をやり直し
        redirect_to cart_path, alert: "商品の価格が変更されたため、注文できませんでした。注文する場合はカートを空にして再度商品を入れて下さい。" and return
      end
    end

    # 注文レコードを作成
    order = current_user.orders.create(total_price: total_price(cart))

    # カートアイテムをOrderItemに移す
    cart.cart_items.each do |ci|
      # 注文アイテムを保存
      order_item = order.order_items.create(
        item_id: ci.item_id,
        quantity: ci.quantity,
        price: ci.item.price,
        delivery: 0   # 0=未配送
      )
      # 在庫を減らす（在庫数が反映される）
      ci.item.update!(stock: ci.item.stock - ci.quantity)
    end

    # 注文後はカートを空にする
    cart.cart_items.destroy_all
    redirect_to order_path(order), notice: "注文が完了しました。"
  end

  # 注文ステータス
  def status
    @order = current_user.orders.find_by(id: params[:id])
    unless @order
      redirect_to orders_path, alert: "注文が見つかりません。"
      return
    end
  end

  # キャンセル (注文単位でキャンセル、商品ごとだとややこしいから)
  def cancel
    @order = current_user.orders.find_by(id: params[:id])
    @order.order_items.each do |oi|
      if oi.delivery == 0  # 未配送ならキャンセル可
        oi.update(delivery: 5)  # 5=キャンセル
        # 在庫を戻す
        oi.item.increment!(:stock, oi.quantity)
      end
    end
    redirect_to order_path(@order), notice: "注文をキャンセルしました。"
  end

  # 返品 (注文単位で返品、キャンセルと同様)
  def return
    @order = current_user.orders.find_by(id: params[:id])
    @order.order_items.each do |oi|
      if oi.delivery == 2
        oi.update(delivery: 3) # 3=返品中
      end
    end
    redirect_to order_path(@order), notice: "返品手続きを開始しました。"
  end

  private def total_price(cart)
    cart.cart_items.sum { |ci| ci.item.price * ci.quantity }
  end
end
