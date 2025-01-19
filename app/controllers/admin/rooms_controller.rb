class Admin::RoomsController < ApplicationController
  before_action :require_admin


  def index
    # 全ルームを一覧で見れる
    @rooms = Room.order(id: :desc).page(params[:page]).per(15)
    @reports = Report.order(created_at: :desc)

    # ここで @accounts を定義
    base_user  = User.all
    base_admin = Admin.all

    # 必要に応じて検索や絞り込みをしてもOK
    # 今はシンプルに全レコードをまとめる例
    merged_records = base_user.to_a + base_admin.to_a

    # 一覧に表示するため、@accounts に詰める
    @accounts = merged_records
  end

  def new
    @room = Room.new
    # 管理者が「ユーザー宛」で新規問い合わせする場合:
    if params[:user_id].present?
      @target_user = User.find_by(id: params[:user_id])
    end
  end

  def create
    subject_val = params[:room][:subject]
    @room = Room.new(subject: subject_val)
    if @room.save
      # 管理者エントリー
      Entry.create!(admin_id: current_admin.id, room_id: @room.id)
      if params[:user_id].present?
        Entry.create!(user_id: params[:user_id], room_id: @room.id)
      end
      redirect_to admin_room_path(@room), notice: "新規問い合わせ(ルーム)を作成しました。"
    else
      flash[:alert] = "新規問い合わせの作成に失敗しました。"
      render :new
    end
  end
  

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.order(:created_at)
    @entries = @room.entries.includes(:user)
  end

  # 管理者が問い合わせに返信するケース
  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update(params[:room])
      redirect_to admin_room_path(@room), notice: "問い合わせ(ルーム)を更新しました。"
    else
      flash[:alert] = @room.errors.full_messages
      render :edit
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    redirect_to admin_rooms_path, notice: "問い合わせ(ルーム)を削除しました。"
  end
end
