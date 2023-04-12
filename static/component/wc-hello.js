import { LewElement } from  "/js/LewElement.js";

export class WCHello extends LewElement {
  constructor() {
      super();
      this.build()
      this.attach(this)
  }

  create(state, props, storage, query) {

    console.log('Build hello')

    storage.blink = "blink"
    storage.hello = "you"

    const style = `<style>a{color: blue;}</style>`;

    const template = `<a id="hello" >Hello ` + storage.hello + ` </a>`;

    return `${style} ${template}`;
  }

  update(state){

    console.log('===== state')
    console.log(state)
    this.innerHTML = 'Hello ' + state
  }
}

customElements.define('wc-hello', WCHello)
