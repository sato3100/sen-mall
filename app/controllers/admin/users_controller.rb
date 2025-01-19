class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    form_params = params[:search] || {}
    keyword     = form_params[:q]

    base_user  = User.all
    base_admin = Admin.all

    # 検索
    if keyword.present?
      like_query = "%#{keyword}%"

      base_user = base_user.where(
        "phone_number LIKE :kw OR email LIKE :kw OR family_name LIKE :kw OR given_name LIKE :kw",
        kw: like_query
      )
      base_admin = base_admin.where(
        "phone_number LIKE :kw OR email LIKE :kw OR family_name LIKE :kw OR given_name LIKE :kw",
        kw: like_query
      )
    end

    merged_records = base_user.to_a + base_admin.to_a
    merged_records.sort_by! { |acc| [ role_order(acc), acc.id ] }
    @accounts = Kaminari.paginate_array(merged_records).page(params[:page]).per(10)
  end

  def show
    if params[:type] == 'admin'
      @admin = Admin.find(params[:id])
    else
      @user = User.find(params[:id])
    end
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new
    @admin.attributes = params[:admin]
    if @admin.save
      @admin.update(full_name: "#{@admin.family_name} #{@admin.given_name}")
      redirect_to admin_users_path, notice: "管理者を作成しました。"
    else
      flash[:alert] = @admin.errors.full_messages
      render :new
    end
  end

  def edit
    if params[:type] == 'admin'
      @admin = Admin.find(params[:id])
    else
      @user = User.find(params[:id])
    end
  end

  def update
    if params[:type] == 'admin'
      @admin = Admin.find(params[:id])
      @admin.attributes = params[:admin]
      if @admin.save
        @admin.update(full_name: "#{@admin.family_name} #{@admin.given_name}")
        redirect_to admin_users_path, notice: "管理者情報を更新しました。"
      else
        flash[:alert] = @admin.errors.full_messages
        render :edit
      end
    else
      @user = User.find(params[:id])
      @user.attributes = params[:user]
      if @user.save
        @user.update(full_name: "#{@user.family_name} #{@user.given_name}")
        redirect_to admin_users_path, notice: "ユーザー情報を更新しました。"
      else
        flash[:alert] = @user.errors.full_messages
        render :edit
      end
    end
  end

  def destroy
    if params[:type] == 'admin'
      @admin = Admin.find_by(id: params[:id])
      unless @admin
        redirect_to admin_users_path, alert: "指定された管理者は既に存在しません。"
        return
      end
      @admin.destroy
      redirect_to admin_users_path, notice: "管理者を削除しました。"
    else
      @user = User.find_by(id: params[:id])
      unless @user
        redirect_to admin_users_path, alert: "指定されたユーザーは既に存在しません。"
        return
      end
      if @user.status == 2
        item_ids = @user.items.ids
        delivering = OrderItem.where(item_id: item_ids, delivery: 1).exists?
        if delivering
          redirect_to admin_users_path, alert: "配送中の商品があるため、削除できません"
        else
          @user.destroy
          redirect_to admin_users_path, notice: "ユーザーを削除しました。"
        end
      else
        @user.destroy
        redirect_to admin_users_path, notice: "ユーザーを削除しました。"
      end
    end
  end


  private def role_order(acc)
    return 0 if acc.is_a?(Admin)
    return 1 if acc.is_a?(User) && acc.status==1
    return 2 if acc.is_a?(User) && acc.status==2
    return 9
  end
end
