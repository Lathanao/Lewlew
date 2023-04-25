import { LewElement } from '/js/LewElement.js'
import { WCHello } from '/component/wc-hello.js'
export class WCBlink extends LewElement {
  constructor() {
    super()
    this.build()
  }

  create(state, props, storage, query) {
    this.addEventListener(
      'click',
      function (e) {
        this.notify('Notify')

        localStorage.setItem('test', test)
      }.bind(this)
    )

    const style = `<script>
                      var blink = document.getElementById('blink')
                      setInterval(function() {
                          blink.style.opacity = (blink.style.opacity == 0 ? 1 : 0)
                      }, 500)
                  </script>`

    const template = `<br><button id="blink">Send Notif</button>`

    return `${template} ${style}`
  }
}

customElements.define('wc-blink', WCBlink)
