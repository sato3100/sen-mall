class SessionsController < ApplicationController
  def new
  end

  def create
    admin = Admin.find_by(email: params[:email])
    if admin&.authenticate(params[:password])
      cookies.signed[:admin_id] = { value: admin.id, expires: 24.hours.from_now }
      redirect_to admin_top_path, notice: "管理者としてログインしました。"
      return
    end

    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      cookies.signed[:user_id] = { value: user.id, expires: 24.hours.from_now }

      if user.status == 2
        redirect_to seller_top_path, notice: "出品者としてログインしました。"
      else
        redirect_to root_path, notice: "ログインしました。"
      end
      return
    end

    flash[:alert] = "メールアドレスまたはパスワードが間違っています。"
    render :new
  end

  def destroy
    cookies.delete(:user_id)
    cookies.delete(:admin_id)
    redirect_to root_path, notice: "ログアウトしました。"
  end
end
