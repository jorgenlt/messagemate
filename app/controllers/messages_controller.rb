class MessagesController < ApplicationController
  def index
    @connected_user_id = params[:user_id]
    @messages = Message.where(user_id: current_user.id, recipient_id: @connected_user_id).or(Message.where(user_id: @connected_user_id, recipient_id: current_user.id))
    @message = Message.new
  end

  def create
    # @chatroom = Chatroom.find(params[:chatroom_id])
    @message = Message.new(message_params)
    @message.chatroom_id = @chatroom
    @message.user = current_user
    if @message.save
      redirect_to chatroom_path(@chatroom)
    else
      flash.alert = "Error. Message was not sent."
    end
  end

  def message_params
    params.require(:message).permit(:message_body)
  end
end
