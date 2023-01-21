class MessagesController < ApplicationController
  def index
    @connected_user_id = params[:user_id]
    @messages = Message.where(user_id: current_user.id, recipient_id: @connected_user_id).or(Message.where(user_id: @connected_user_id, recipient_id: current_user.id))
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    if @message.save
      redirect_to user_messages_path(message_params[:recipient_id])
    else
      flash.alert = "Error. Message was not sent."
    end
  end

  def message_params
    params.require(:message).permit(:message_body, :recipient_id)
  end
end
