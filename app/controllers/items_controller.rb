class ItemsController < ApplicationController
  def index
    base = Item.where("stock > 0").order(:id)
    word = params[:word]
    category_name = params[:category]
    min_price = params[:min_price].to_i if params[:min_price].present?
    max_price = params[:max_price].to_i if params[:max_price].present?

    if min_price.present? && min_price < 1
      min_price = 1
    end

    base = base.by_category(category_name) if category_name.present?
    base = base.price_gte(min_price) if min_price.present?
    base = base.price_lte(max_price) if max_price.present?
    if word.present?
      base = base.where("name LIKE ?", "%#{word}%")
    end

    @items = base
    .page(params[:page]).per(20)
    if @items.empty?
      flash.now[:alert] = "該当する商品が見つかりませんでした"
    end
  end

  def show
    @item = Item.find(params[:id])
    @reviews = @item.reviews
  end

  def reviews
    @item = Item.find(params[:id])
    @reviews = @item.reviews
  end
end
