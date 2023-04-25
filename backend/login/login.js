import AbstractView from '/js/AbstractView.js'
import '/component/wc-blink.js'
import '/component/wc-hello.js'
import '/component/wc-button.js'

import '/component/wc-event-button.js'
import '/component/wc-event-input.js'
export default class extends AbstractView {
  constructor(params) {
    super(params)
    this.setTitle('Login')
    this.__template_path = '/backend/login.html'

    const eventAwesome = new CustomEvent('awesome', {
      bubbles: true,
      detail: { text: () => textarea.value },
    })
  }
}
