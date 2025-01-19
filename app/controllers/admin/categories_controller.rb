class Admin::CategoriesController < ApplicationController
  before_action :require_admin

  def index
    @categories = Category.order(:id)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to admin_categories_path, notice: "ジャンルを作成しました"
    else
      flash[:alert] = @category.errors.full_messages
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(params[:category])
      redirect_to admin_categories_path, notice: "ジャンルを更新しました"
    else
      flash[:alert] = @category.errors.full_messages
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    # 商品が割り当てられていたら削除不可
    if @category.items.exists?
      redirect_to admin_categories_path, alert: "商品が存在するため削除できません"
    else
      @category.destroy
      redirect_to admin_categories_path, notice: "ジャンルを削除しました"
    end
  end
end