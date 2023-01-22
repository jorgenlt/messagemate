class ChatroomsController < ApplicationController
  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end

  def new
    @chatroom = Chatroom.new
  end

  def create
    @chatroom = Chatroom.new
    @chatroom.recipient_id = User.where(username: chatroom_params(:username))
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
