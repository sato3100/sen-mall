class CartItemsController < ApplicationController
  before_action :login_required

  def create
    # 商品と数量を取得
    item = Item.find_by(id: params[:item_id])
    quantity = params[:quantity].to_i

    # 商品が見つからない場合
    unless item
      redirect_to items_path, alert: "商品が見つかりませんでした。" and return
    end

    # 数量が1未満の場合
    if quantity < 1
      redirect_to item_path(item), alert: "有効な数量を選択してください。" and return
    end

    # ユーザーのカートを取得
    cart = current_user.cart || Cart.create(user: current_user)
    # カート内に同じ商品があるかを確認
    cart_item = cart.cart_items.find_by(item: item)

    if cart_item
      # すでにカートにある場合は数量を加算する
      new_quantity = cart_item.quantity + quantity
      if new_quantity > item.stock
        # 在庫以上ならエラー
        redirect_to item_path(item), alert: "選択された数量は在庫数を超えています。" and return
      else
        # 在庫以内なら更新
        cart_item.update(quantity: new_quantity, price: item.price)
      end
    else
      # カートに無い商品は新規作成
      if quantity > item.stock
        redirect_to item_path(item), alert: "選択された数量は在庫数を超えています。" and return
      else
        cart.cart_items.create(item: item, quantity: quantity, price: item.price)
      end
    end

    redirect_to cart_path, notice: "カートに追加しました。"
  end

  def update
    cart_item = current_user.cart.cart_items.find_by(id: params[:id])

    unless cart_item
      redirect_to cart_path, alert: "カートアイテムが見つかりませんでした。" and return
    end

    new_quantity = params[:cart_item][:quantity].to_i

    if new_quantity < 1
      cart_item.destroy
      redirect_to cart_path, notice: "カートアイテムを削除しました。" and return
    elsif new_quantity > cart_item.item.stock
      redirect_to cart_path, alert: "選択された数量は在庫数を超えています。" and return
    else
      cart_item.update(quantity: new_quantity, price: cart_item.item.price)
      redirect_to cart_path, notice: "カートを更新しました。"
    end
  end

  def destroy
    cart_item = current_user.cart.cart_items.find_by(id: params[:id])

    if cart_item
      cart_item.destroy
      redirect_to cart_path, notice: "カートから削除しました。"
    else
      redirect_to cart_path, alert: "カートアイテムが見つかりませんでした。"
    end
  end
end
