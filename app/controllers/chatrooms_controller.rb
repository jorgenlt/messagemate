class ChatroomsController < ApplicationController
  def index
    @new_chatroom = Chatroom.new
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
    @new_chatroom = Chatroom.new
  end

  # A chatroom is created with recipients id and username,
  # and senders user_id. If the two already have a chatroom
  # the user will be alerted and the chatroom will not be created.
  def create
    if User.find_by(username: chatroom_params[:username]).present?
      recipient = User.find_by(username: chatroom_params[:username])
      if Chatroom.where(user_id: current_user.id, recipient_id: recipient.id).exists? ||
         Chatroom.where(user_id: recipient.id, recipient_id: current_user.id).exists?
        redirect_to root_path
        flash.alert = "You already have a chat going with this user."
      else
        @chatroom = Chatroom.new(chatroom_params)
        @chatroom.user_id = current_user.id
        @chatroom.recipient_id = recipient.id
        if @chatroom.save
          redirect_to chatroom_path(@chatroom)
        else
          redirect_to root_path
          flash.alert = "Error! Chatroom was not created."
        end
      end
    else
      redirect_to root_path
      flash.alert = "User does not exist. Try again."
    end
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:username)
  end
end
