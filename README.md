<base target="_blank">

# MessageMate - Instant messaging app

The app is live at [messagemate.me](https://www.messagemate.me).

Download for Android: [messagemate.apk](https://www.jorgenlt.me/messagemate.apk)

</br>
</br>
<div style="display: flex;">
  <img
    src="https://user-images.githubusercontent.com/108831121/215315086-6bec3102-2c50-441a-a5b1-2ec071d5eaee.png"
    width="300"
    height="auto">
  <img
    src="https://user-images.githubusercontent.com/108831121/215315089-bee8cac9-edbe-49c4-aac7-64e01657c5a7.png"
    width="300"
    height="auto">
  <a
    href="https://url.jorgenlt.me/EaOwjv"
    title="MessageMate demo">
    <img
      src="https://user-images.githubusercontent.com/108831121/218423865-8169d956-f8fc-4910-94c7-74b38967d6b2.png"
      alt="MessageMate demo"
      width="300"
    />
  </a>

</div>
</br>
<div>
  <img src="https://user-images.githubusercontent.com/108831121/215315281-a16534b2-b757-43c2-a592-8fd72bf2cc23.png" width="600" height="auto">
</div>
</br>
</br>

## Features
- A user can sign up and sign in, and add a picture to their profile. Account information and profile picture can be edited by the user at a later time.
- A user can add another user to start a new conversation ("chatroom").
- A user can send and receive messages in real-time.
- Secure authentication and authorization.
- Mobile responsiveness to ensure an optimal user experience. The app can be downloaded as an apk-file for android or used in the browser on desktop or mobile.
- Ligthweight, fast and simple messaging web application.

</br>

## Technologies
MessageMate is built with [Ruby on Rails](https://rubyonrails.org/) on both backend and frontend. Data is stored in a PostgreSQL database and Cloudinary is used for cloud storage of the profile image files. Authentication and authorization is being handled with the [Devise gem](https://github.com/heartcombo/devise). This ensures the user to
securely sign in and sign up to the application, authorization is given to the user so that they can only view their own content. The application is using Websocket with Action Cable for real-time, two-way communication between the server and client. This allows the exchange of messages in both directions without the need for a new request to be made for each message.

The application is additionally supported by Webpack, simple_form, stimulus and bootstrap.

</br>

## Technical challenges
### Making the messages appear in real time for sender and receiver
[Action Cable](https://guides.rubyonrails.org/action_cable_overview.html) is a feature of Ruby on Rails that provides a framework for using WebSockets in a Rails application. It allows us to create "channels" in our application, which can receive and broadcast messages in real-time. This makes it possible to build real-time applications, such as chat apps, posts, comments, and other features that requires real-time updates and notifications.

On connection to the chatrooom page the user is subscribed to the channel Chatroom. Using javascript the messages are inserted into the DOM.

```.js
// app/javascript/controllers/chatroom_subscription_controller.js

// when the user connects to the page a subscription to the channel is made.
  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ChatroomChannel", id: this.chatroomIdValue },
      { received: data => this.#insertMessageAndScrollDown(data) }
      )
      console.log(`Subscribed to the chatroom with the id ${this.chatroomIdValue}.`)
  }

  #insertMessageAndScrollDown(data) {
    // logic to know if the sender is the current_user
    const currentUserIsSender = this.currentUserIdValue === data.sender_id

    // creating the whole message from the `data.message` string
    const messageElement = this.#buildMessageElement(currentUserIsSender, data.message)

    // inserting the `message` in the DOM
    this.messagesTarget.insertAdjacentHTML("beforeend", messageElement)
    window.scrollTo(0, document.body.scrollHeight);
  }

  // function to build a complete message with its two wrapping div,
  // passing it the currentUserIsSender boolean, and the message string
  // coming from the data:
  #buildMessageElement(currentUserIsSender, message) {
    return `
    <div class="message-row d-flex ${this.#justifyClass(currentUserIsSender)}">
    <div class="${this.#userStyleClass(currentUserIsSender)}">
    ${message}
    </div>
    </div>
    `
  }

  // two functions to return the relevant classes to position and style the message
  // the user on the right and the recipient on the left, like other popular messaging services.
  #justifyClass(currentUserIsSender) {
    return currentUserIsSender ? "justify-content-end" : "justify-content-start"
  }

  #userStyleClass(currentUserIsSender) {
    return currentUserIsSender ? "sender-style" : "receiver-style"
  }

  // reset the send message input field after the message is sent
  resetForm(event) {
    event.target.reset()
  }

  // unsubscribe from the channel when user leaves the page
  disconnect() {
    console.log("Unsubscribed from the chatroom")
    this.channel.unsubscribe()
  }
}
```

</br>

On the server-side each new message is broadcasted if the message is created and saved successfully.

</br>

```.rb
# app/controllers/messages_controller.rb

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
```

</br>

The messages are displayed in the chatroom show view.

</br>

```.html
<!-- app/views/chatrooms/show.html.erb -->

<div class="chat"
  data-controller="chatroom-subscription"
  data-chatroom-subscription-chatroom-id-value="<%= @chatroom.id %>"
  data-chatroom-subscription-current-user-id-value="<%= current_user.id %>"
>
  <div class="messages" data-chatroom-subscription-target="messages">
    <% @chatroom.messages.each do |message| %>
      <div class="d-flex <%= message.sender?(current_user) ? 'justify-content-end' : 'justify-content-start' %>">
        <div class="<%= message.sender?(current_user) ? 'sender-style' : 'receiver-style' %>">
          <div data-controller="messagesent">
            <div data-messagesent-target="messagesent" class="d-none message-sent-at">
              <span>
              Sent <%= time_ago_in_words(message.created_at) %> ago.
              </span>
            </div>
            <div class="message" data-action="click->messagesent#messageSent">
              <div class="message-content">
                <p><%= message.message_body %></p>
              </div>
            </div>
          </div>
        </div>
      </div>
    <% end %>
  </div>

  <div id="new-message">
    <%= simple_form_for [@chatroom, @message],
      html: { data: { action: "turbo:submit-end->chatroom-subscription#resetForm" },
      class: "d-flex" } do |f| %>
      <div id="message-form">
        <div class="message-text">
          <%= f.input :message_body,
                      as: :text,
                      label: false,
                      placeholder: "New message",
                      input_html: { rows: 1 }
                    %>
        </div>
        <div class="send-message">
          <%= f.button :submit, 'SEND', class: "submit-button"%>
        </div>
      </div >
    <% end %>
  </div>
</div>
```

</br>

## Upcoming features
- A user can see other users profile.
- A user can add personal information to their profile.
- Notifications in android app.
- A user can start a group chat.
