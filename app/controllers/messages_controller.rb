class MessagesController < ApplicationController
  def index
    @messages = Message.all
    @message = Message.new()
  end

  def create
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
