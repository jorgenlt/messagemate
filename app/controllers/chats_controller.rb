class ChatsController < ApplicationController

  def chats
    @messages = Message.where(user_id: current_user.id).or(Message.where(recipient_id: current_user.id))
    @conversations = @messages.select(:user_id, :recipient_id).distinct
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
