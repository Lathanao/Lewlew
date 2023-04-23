import { LewElement } from "/js/LewElement.js";

export class WCButton extends LewElement {
  constructor() {
    super();
    this.build();
    this.attach(this);

    this.addEventListener(
      "click",
      function (e) {
        localStorage.setItem('test', 'two')
        console.log("========== LocalStorage Mod ============");
        console.log(localStorage);

        this.dispatchEvent(
          new CustomEvent('awesome', 
          { bubbles: true, 
            detail: { text: () => 'yo' } 
          }))
      }
    );

    this.addEventListener('awesome', e => console.log("Get event from WCButton"));
  }

  create(state, props, storage, query) {
    console.log("========== Build Button ============");
    console.log(state);
    console.log(props);
    console.log(storage);
    console.log(query);

    Storage.blink = "blink";
    Storage.hello = "you";

    const style = `<style>.btn{color: red;}</style>`;
    const template = `<br><button id="btn">Send storage event</button>`;

    return `${style} ${template}`;
  }
}

customElements.define("wc-button", WCButton);
