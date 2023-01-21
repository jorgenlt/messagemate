class MessagesController < ApplicationController
  def index
    @messages = Message.all
    @message = Message.new()
  end

  def create
    @message = Message.new(message_params)
    raise
    # @message.recipient_id = params[:recipient_id]
    if @message.save
      flash.notice = "Message sent"
    else
      flash.alert = "Error. Message was not sent."
    end
  end

  def message_params
    raise
    params.require(:message).permit(:message_body, :recipient_id)
  end
end
