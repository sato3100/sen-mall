class MessagesController < ApplicationController
  def create
    @room = Room.find(params[:room_id])
    msg_text = params.dig(:message, :message) || params[:message]

    @message = Message.new(room_id: @room.id)

    if current_admin
      @message.admin_id = current_admin.id
    elsif current_user
      @message.user_id = current_user.id
    else
      flash[:alert] = "ログインが必要です。"
      redirect_back(fallback_location: root_path) and return
    end

    @message.message = msg_text

    if @message.save
      if current_admin
        redirect_to admin_room_path(@room), notice: "管理者メッセージを送信しました。"
      else
        redirect_to room_path(@room), notice: "メッセージを送信しました。"
      end
    else
      flash[:alert] = @message.errors.full_messages.join(", ")
      if current_admin
        redirect_to admin_room_path(@room)
      else
        redirect_to room_path(@room)
      end
    end
  end
end
