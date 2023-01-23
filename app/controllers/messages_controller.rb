class MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = Message.new(message_params)
    @message.chatroom_id = @chatroom.id
    @message.user_id = current_user.id

    # setting sender/receiver of the message
    if current_user.id == @chatroom.user_id
      @message.recipient_id = @chatroom.recipient_id
    else
      @message.recipient_id = @chatroom.user_id
    end

    # instant message with action cable
    if @message.save
      ChatroomChannel.broadcast_to(
        @chatroom,
        render_to_string(partial: "message", locals: {message: @message})
      )
      head :ok
    else
      render "chatrooms/show", status: :unprocessable_entity
      flash.alert = "Error. Message was not sent."
    end
  end

  def message_params
    params.require(:message).permit(:message_body, :chatroom_id)
  end
end
