class ChatroomsController < ApplicationController
  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end

  def new
    @chatroom = Chatroom.new
  end

  # A chatroom is created with recipients id and username,
  # and senders user_id.
  def create
    @chatroom = Chatroom.new(chatroom_params)
    @chatroom.user_id = current_user.id
    @chatroom.recipient_id = User.find_by(username: @chatroom.username).id
    # @chatroom.recipient_id = User.where(username: chatroom_params[:username])
    if @chatroom.save
      redirect_to chatroom_path(@chatroom)
    else
      flash.alert = "Error! Chatroom was not created."
    end
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:username)
  end
end
