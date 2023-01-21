class ChatsController < ApplicationController

  def chats
    @messages = Message.all
  end

  def create
    @message = Message.new(message_params)
  end


  private

  def message_params
    params.require(:message).permit(:message_body)
  end
end
