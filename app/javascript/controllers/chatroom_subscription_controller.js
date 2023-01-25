import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="chatroom-subscription"
export default class extends Controller {
  static values = { chatroomId: Number, currentUserId: Number }
  static targets = ["messages", "messagesent"]


  connect() {
    window.scrollTo(0, document.body.scrollHeight);
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
      // this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
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
    #justifyClass(currentUserIsSender) {
      return currentUserIsSender ? "justify-content-end" : "justify-content-start"
    }

    #userStyleClass(currentUserIsSender) {
      return currentUserIsSender ? "sender-style" : "receiver-style"
    }

    resetForm(event) {
      event.target.reset()
    }

    disconnect() {
      console.log("Unsubscribed from the chatroom")
      this.channel.unsubscribe()
    }
  }
