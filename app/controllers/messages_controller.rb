class MessagesController < ApplicationController
  # skip authorization on MessagesController with the before_action
  before_action :skip_authorization

  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = Message.new(message_params)
    @message.chatroom_id = @chatroom.id
    @message.user_id = current_user.id

    if message_params[:message_body].empty?
      # submit button 'send' does nothing.
    else
      # setting sender/receiver of the message
      if current_user.id == @chatroom.user_id
        @message.recipient_id = @chatroom.recipient_id
      else
        @message.recipient_id = @chatroom.user_id
      end

      # if the message is saved successfully the message is broadcasted to the Chatroom channel.
      if @message.save
        ChatroomChannel.broadcast_to(
          @chatroom,
          message: render_to_string(partial: "message", locals: { message: @message }),
          sender_id: @message.user.id
        )
        head :ok
      else
        render "chatrooms/show", status: :unprocessable_entity
        flash.alert = "Error. Message was not sent."
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:message_body, :chatroom_id)
  end
end
