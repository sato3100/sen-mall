class ReportsController < ApplicationController
  before_action :login_required

  def create
    if params[:item_id].present?
      item = Item.find(params[:item_id])
      Report.create!(
        reporter_id: current_user.id,
        reported_user_id: item.user_id,
        item_id: item.id
      )
      redirect_back(fallback_location: root_path, notice: "通報しました。")

    elsif params[:review_id].present?
      review = Review.find(params[:review_id])
      Report.create!(
        reporter_id: current_user.id,
        reported_user_id: review.user_id,
        review_id: review.id
      )
      redirect_back(fallback_location: root_path, notice: "レビューを通報しました。")

    else
      redirect_back(fallback_location: root_path, alert: "通報先が指定されていません。")
    end
  end
end



