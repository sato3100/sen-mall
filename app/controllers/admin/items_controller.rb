class Admin::ItemsController < ApplicationController
  before_action :require_admin

  def index
    @items = Item.order(:id).page(params[:page]).per(30)
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
    @categories = Category.all
  end

  def update
    @item = Item.find(params[:id])
    @item.assign_attributes(params[:item])
    if @item.save
      redirect_to admin_item_path(@item), notice: "商品情報を更新しました。"
    else
      flash[:alert] = @item.errors.full_messages
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to admin_items_path, notice: "出品を取り消しました。"
  end
end
