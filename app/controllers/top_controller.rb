class TopController < ApplicationController

  def index
    @recommended_items = Item.where("stock > 0").order("items.id")
    .page(params[:page]).per(20)
  end
end
