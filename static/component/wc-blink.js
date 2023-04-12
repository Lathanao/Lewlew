import { LewElement } from  "/js/LewElement.js";
import { WCHello } from  "/component/wc-hello.js";
export class WCBlink extends LewElement {


  constructor() {
      super()
      this.build()     
  }

  create(state, props, storage, query) {
 
    this.addEventListener("click", function(e) {

      console.log("Notify From blink")
      this.notify('Notify')

    }.bind(this))

    console.log('Build blink')
    console.log(storage.blink)

    const style = `<script>
                      console.log('Add js blink')
                      var blink = document.getElementById('blink');
                      setInterval(function() {
                          blink.style.opacity = (blink.style.opacity == 0 ? 1 : 0);
                          console.log('Blink')
                      }, 500);
                  </script>`;

    const template = `<br><button id="blink">${storage.label}</button>`;

    return `${template} ${style}`;
  }
}

customElements.define('wc-blink', WCBlink)





