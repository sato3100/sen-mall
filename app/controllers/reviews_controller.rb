class ReviewsController < ApplicationController
  before_action :set_item_and_review, only: [:edit, :update, :destroy]

  # レビュー一覧
  def index
    if params[:item_id]
      @item = Item.find(params[:item_id])
      @reviews = @item.reviews
    elsif params[:user_id]
      @user = User.find_by(id: params[:user_id])
      if @user.nil?
        redirect_to root_path, alert: "ユーザーが存在しません。" and return
      end
      @reviews = @user.reviews
    else
      redirect_to root_path, alert: "不正なリクエストです。"
    end
  end

  # 新規作成フォーム
  def new
    @item = Item.find(params[:item_id])
    @review = @item.reviews.build
  end

  # 登録処理
  def create
    @item = Item.find(params[:item_id])
    @review = @item.reviews.build(review_params)
    @review.user_id = current_user.id

    if @review.save
      redirect_to item_reviews_path(@item), notice: "レビューを投稿しました。"
    else
      flash[:alert] = @review.errors.full_messages
      render :new
    end
  end

  # 編集フォーム
  def edit
    redirect_to item_reviews_path(@item), alert: "他人のレビューは編集できません。" if @review.user_id != current_user.id
  end

  # 更新処理
  def update
    if @review.user_id != current_user.id
      redirect_to item_reviews_path(@item), alert: "他人のレビューは編集できません。" and return
    end

    if @review.update(review_params)
      redirect_to user_reviews_path(@item), notice: "レビューを更新しました。"
    else
      flash[:alert] = @review.errors.full_messages
      render :edit
    end
  end

  # 削除処理
  def destroy
    unless current_admin || (@review.user_id == current_user&.id)
      redirect_to item_reviews_path(@item), alert: "他人のレビューは削除できません。" and return
    end

    @review.destroy
    redirect_to user_reviews_path(@review.user_id), notice: "レビューを削除しました。"
  end

  private def set_item_and_review
    @item   = Item.find(params[:item_id])
    @review = @item.reviews.find(params[:id])
  end

  private def review_params
    params.require(:review).permit(:rating, :content)
  end
end
