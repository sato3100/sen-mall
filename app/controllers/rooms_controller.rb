class RoomsController < ApplicationController
  before_action :login_required

  # ルーム一覧
  def index
    my_room_ids = current_user.entries.pluck(:room_id)
    @all_entries = Entry.where(room_id: my_room_ids)
    @another_entries = @all_entries.reject do |entry|
      entry.user_id == current_user.id
    end
    @admin_user = Admin.first
end

  # ルーム詳細
  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.order(:created_at)
    @message  = Message.new

    # 相手ユーザーを特定
    @entries       = @room.entries
    @another_entry = @entries.where.not(user_id: current_user.id).first
    @target_user   = @another_entry&.user
  end

  # ルーム新規作成フォーム
  def new
    @room = Room.new

    if params[:admin_inquiry].present?
      @target_admin = Admin.first
    elsif params[:user_id].present?
      @target_user = User.find_by(id: params[:user_id])
    end
  end

    # ルーム作成
    def create
      subject_val = params[:room][:subject]

      @room = Room.new(subject: subject_val)

      if @room.save
        if params[:admin_inquiry].present?
          Entry.create!(user_id: current_user.id, room_id: @room.id)
          Entry.create!(admin_id: Admin.first.id, room_id: @room.id)
        elsif params[:user_id].present?
          Entry.create!(user_id: current_user.id, room_id: @room.id)
          Entry.create!(user_id: params[:user_id], room_id: @room.id)
        end
        redirect_to room_path(@room), notice: "ルームを作成しました。"
      else
        flash[:alert] = "ルームの作成に失敗しました。"
        redirect_to new_room_path(user_id: params[:user_id])
      end
    end
end
