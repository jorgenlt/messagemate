import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messagesent"
export default class extends Controller {
  static targets = ["messagesent"]

  messageSent() {
    this.messagesentTarget.classList.toggle("d-none");
  }
}
