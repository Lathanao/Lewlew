import { LewElement } from "/js/LewElement.js";

export class WCHello extends LewElement {
  constructor() {
    super();
    this.build();
    this.attach(this);
    localStorage.setItem('test', 'one')

    console.log("========== LocalStorage ============");
    console.log(localStorage);

    // this.addEventListener(
    //   "storage",
    //   function (e) {
    //     console.log("Get event from WCHello");
    //   }
    // );

    this.addEventListener('awesome', e => console.log("Get event from WCHello"));
  }

  create(state, props, storage, query) {
    console.log("========== Build Hello ============");
    console.log(state);
    console.log(props);
    console.log(storage);
    console.log(query);

    Storage.blink = "blink";
    Storage.hello = "you";

    const style = `<style>a{color: blue;}</style>`;
    const template = `<a id="hello" >Hello ` + Storage.hello + ` </a>`;

    return `${style} ${template}`;
  }

  update(state, props, storage, query) {
    console.log("========== 2 update Hello ============");
    console.log(state);
    console.log(props);
    console.log(storage);
    console.log(query);
    this.innerHTML = "Hello " + state;
  }
}

customElements.define("wc-hello", WCHello);
