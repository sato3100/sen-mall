class CartItemsController < ApplicationController
  before_action :login_required

  def create
    item = Item.find_by(id: params[:item_id])
    quantity = params[:quantity].to_i

    unless item
      redirect_to items_path, alert: "商品が見つかりませんでした。" and return
    end

    if quantity < 1
      redirect_to item_path(item), alert: "有効な数量を選択してください。" and return
    end

    cart = current_user.cart || Cart.create(user: current_user)

    cart_item = cart.cart_items.find_by(item: item)

    if cart_item
      new_quantity = cart_item.quantity + quantity
      if new_quantity > item.stock
        redirect_to item_path(item), alert: "選択された数量は在庫数を超えています。" and return
      else
        cart_item.update(quantity: new_quantity)
      end
    else
      if quantity > item.stock
        redirect_to item_path(item), alert: "選択された数量は在庫数を超えています。" and return
      else
        cart.cart_items.create(item: item, quantity: quantity)
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
      cart_item.update(quantity: new_quantity)
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
