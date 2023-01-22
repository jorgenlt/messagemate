class ChatroomsController < ApplicationController
  def index
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end

  def new
    @chatroom = Chatroom.new
  end

  # A chatroom is created with recipients id and username,
  # and senders user_id. If the two already have a chatroom
  # the user will be alerted and the chatroom will not be created.
  def create
    recipient = User.find_by(username: chatroom_params[:username])
    if Chatroom.where(user_id: current_user.id, recipient_id: recipient.id).exists? ||
       Chatroom.where(user_id: recipient.id, recipient_id: current_user.id).exists?
      redirect_to new_chatroom_path
      flash.alert = "You already have a chat going with this user."
    else
      @chatroom = Chatroom.new(chatroom_params)
      @chatroom.user_id = current_user.id
      @chatroom.recipient_id = recipient.id
      # @chatroom.recipient_id = User.where(username: chatroom_params[:username])
      if @chatroom.save
        redirect_to chatroom_path(@chatroom)
      else
        redirect_to new_chatroom_path
        flash.alert = "Error! Chatroom was not created."
      end
    end
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:username)
  end
end
