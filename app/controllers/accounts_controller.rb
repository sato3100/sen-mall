class AccountsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.full_name = "#{@user.family_name} #{ @user.given_name}"
    @user.status = 1  # buyer

    if @user.save
      cookies.signed[:user_id] = { value: @user.id, expires: 24.hours.from_now }
      redirect_to root_path, notice: "購入者登録が完了しました。"
    else
      flash[:alert] = @user.errors.full_messages
      render :new
    end
  end
end
