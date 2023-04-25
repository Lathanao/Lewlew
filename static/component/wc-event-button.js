import { LewElement } from '/js/LewElement.js'

export class WCEventButton extends LewElement {
  constructor() {
    super()
    this.build()

    this.addEventListener(
      'click',
      function (e) {
        this.dispatch('up-from-button', 'yoyo')
      }.bind(this)
    )
  }

  create(state, props, storage, query) {
    const template = `<button id="btn" class="px-4 py-2 rounded text-white inline-block shadow-lg bg-blue-500 hover:bg-blue-600">Click event</a>`

    return template
  }
}

customElements.define('wc-event-button', WCEventButton)
