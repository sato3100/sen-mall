class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :current_cart
  helper_method :require_admin
  helper_method :current_admin

  # 例外クラスの定義
  class LoginRequired < StandardError; end
  class Forbidden < StandardError; end

  # 環境に応じた例外処理
  if Rails.env.production? || ENV["RESCUE_EXCEPTIONS"]
    rescue_from StandardError, with: :rescue_internal_server_error
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
    rescue_from ActionController::ParameterMissing, with: :rescue_bad_request
  end

  rescue_from LoginRequired, with: :rescue_login_required
  rescue_from Forbidden, with: :rescue_forbidden

  private def current_user
    User.find_by(id: cookies.signed[:user_id]) if cookies[:user_id]
  end

  private def login_required
    raise LoginRequired unless current_user
  end

  private def rescue_login_required
    redirect_to new_session_path, alert: "ログインが必要です。"
  end

  private def update_expiration_time
    cookies[:user_id] = { value: cookies[:user_id], expires: 24.hour.from_now }
  end

  private def current_admin
    Admin.find_by(id: cookies.signed[:admin_id]) if cookies[:admin_id]
  end

  private def require_admin
    unless current_admin
      redirect_to new_session_path, alert: "管理者権限が必要です。"
    end
  end

  def current_cart
    if session[:cart_id]
      cart = Cart.find_by(id: session[:cart_id])
      if cart
        return cart
      else
        session[:cart_id] = nil
      end
    end

    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  private def rescue_internal_server_error(exception)
    logger.error(exception.message)
    logger.error(exception.backtrace.join("\n"))
    render file: Rails.root.join("public", "500.html"), status: :internal_server_error, layout: false
  end

  private def rescue_not_found(exception)
    logger.error(exception.message)
    render file: Rails.root.join("public", "404.html"), status: :not_found, layout: false
  end

  private def rescue_bad_request(exception)
    logger.error(exception.message)
    render file: Rails.root.join("public", "400.html"), status: :bad_request, layout: false
  end

  private def rescue_forbidden(exception)
    logger.error(exception.message)
    render file: Rails.root.join("public", "403.html"), status: :forbidden, layout: false
  end
end