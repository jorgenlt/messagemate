class ChatsController < ApplicationController

  def _chats

  end

  def create
    @user = current_user
    @message = Message.new(message_params)
  end


  private

  def message_params
    params.require(:message).permit(:message_body)
  end
end
