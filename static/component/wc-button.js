import { LewElement } from '/js/LewElement.js'

export class WCButton extends LewElement {
  constructor() {
    super()
    this.build()
    this.attach(this)

    this.addEventListener('click', function (e) {
      this.dispatchEvent(
        new CustomEvent('awesome', {
          bubbles: true,
          detail: { text: () => 'yo' },
        })
      )
    })
  }

  create(state, props, storage, query) {
    const style = `<style>.btn{color: red;}</style>`
    const template = `<br><button id="btn">Send storage event</button>`

    return `${style} ${template}`
  }
}

customElements.define('wc-button', WCButton)
