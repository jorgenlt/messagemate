class ChatroomsController < ApplicationController
  helper_method [
    :recipient,
    :find_chatroom,
    :username,
    :recent_chat
  ]

  def index
    @new_chatroom = Chatroom.new

    @chatroom = policy_scope(Chatroom)
  end

  def show

    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
    @new_chatroom = Chatroom.new

    # authorize viewers of the chatrooms
    @chatrooms = policy_scope(Chatroom)
    authorize @chatroom
  end

  def new
  end

  # A chatroom is created with recipients id and username,
  # and senders user_id. If the two already have a chatroom
  # the user will be alerted and the chatroom will not be created.
  def create
    if User.find_by(username: chatroom_params[:username]).present?
      recipient = User.find_by(username: chatroom_params[:username])
      if Chatroom.where(user_id: current_user.id, recipient_id: recipient.id).exists? ||
        Chatroom.where(user_id: recipient.id, recipient_id: current_user.id).exists?
        redirect_to root_path
        flash.alert = "You already have a chat going with this user."
      else
        @chatroom = Chatroom.new(chatroom_params)
        @chatroom.user_id = current_user.id
        @chatroom.recipient_id = recipient.id
        if @chatroom.save
          redirect_to chatroom_path(@chatroom)
        else
          redirect_to root_path
          flash.alert = "Error! Chatroom was not created."
        end
      end
    else
      redirect_to root_path
      flash.alert = "User does not exist. Try again."
    end

    # authorize everyone to create a new chatroom with another user.
    @chatroom = policy_scope(Chatroom)
    authorize @chatroom
  end

  def recipient(chatroom)
    if chatroom.user_id == current_user.id
      User.find(chatroom.recipient_id)
    else
      User.find(chatroom.user_id)
    end
  end

  def username(chatroom)
    if chatroom.user_id == current_user.id
      User.find(chatroom.recipient_id).username
    else
      User.find(chatroom.user_id).username
    end
  end

  def recent_chat(chatroom)
    if Message.where(chatroom_id: chatroom.id).length == 0
      "Send a new message."
    else
      Message.where(chatroom_id: chatroom.id).last.message_body
    end
  end

  def find_chatroom(user)
    Chatroom.where(user_id: user.id).or(Chatroom.where(recipient_id: user.id))
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:username)
  end
end
