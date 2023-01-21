class MessagesController < ApplicationController
  def index

    @connected_user_id = params[:user_id]
    @messages = Message.where(user_id: current_user.id, recipient_id: @connected_user_id).or(Message.where(user_id: @connected_user_id, recipient_id: current_user.id))
    @message = Message.new


  end

  def create
    raise
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    # @message.recipient_id = params[:recipient_id]
    if @message.save
      flash.notice = "Message sent"
      redirect_to user_messages_path(current_user.id)
    else
      flash.alert = "Error. Message was not sent."
    end
  end

  def message_params

    params.require(:message).permit(:message_body, :recipient_id)
  end
end
