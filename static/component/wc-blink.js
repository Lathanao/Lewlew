/* eslint no-undef: 0 */
export class WCBlink extends ChainElement {
  constructor() {
      super(initialState);
  }

  builder(state, props, storage, query) {
      const style = `<style>a{color: red;}</style>`;

      const template = `<a>${storage.bank}</a>`;
      storage.blink = "blink"

      console.log('sadasdsad')
      console.log(storage)
      console.log(this.testt())

      return `${style} ${template}`;
  }
}

customElements.define('wc-blink', WCBlink)
