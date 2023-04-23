/* eslint no-undef: 0 */
import { interpolateTable } from "/static/js/tools/interpolateTable.js";

export class WCTemplateJson extends HTMLElement {
  static get observedAttributes() {
    return ["src", "context"];
  }

  attributeChangedCallback(name, oldValue, newValue) {
    if (!this.__initialized) {
      return;
    }
    if (oldValue !== newValue) {
      this[name] = newValue;
    }
  }

  get src() {
    return this.getAttribute("src");
  }
  set src(value) {
    this.setAttribute("src", value);
    this.setSrc();
    this.render();
  }

  get context() {
    return this.getAttribute("context");
  }
  set context(value) {
    this.setAttribute("context", value);
    this.setContext();
    this.render();
  }

  constructor() {
    super();
    this.__initialized = false;
    this.__template = "";
    this.__datasource = {};
  }

  async connectedCallback() {
    let payload = {
      token: "vBiSS-7BEKAdQFLpm67O8A",
      data: {
        name: "nameFirst",
        email: "internetEmail",
        phone: "phoneHome",
        _repeat: 10,
      },
    };

    // await fetch("https://app.fakejson.com/q", {
    //   method: 'POST', // *GET, POST, PUT, DELETE, etc.
    //   mode: 'cors', // no-cors, *cors, same-origin
    //   cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
    //   credentials: 'same-origin', // include, *same-origin, omit
    //   headers: {
    //     'Content-Type': 'application/json'
    //     // 'Content-Type': 'application/x-www-form-urlencoded',
    //   },
    //   redirect: 'follow', // manual, *follow, error
    //   referrerPolicy: 'no-referrer', // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
    //   body: JSON.stringify(payload) // body data type must match "Content-Type" header
    // }).then(res => res.json())
    // .then(res => this.__datasource = res);

    await fetch("https://jsonplaceholder.typicode.com/users")
      .then((res) => res.json())
      .then((res) => (this.__datasource = res));

    if (this.hasAttribute("template")) {
      await fetch(this.getAttribute("template"))
        .then((res) => res.text())
        .then((res) => (this.__template = res));
    }

    this.render();
  }

  render() {
    this.innerHTML = interpolateTable(this.__template, this.__datasource);
    this.__initialized = true;
  }
}

customElements.define("wc-template-json", WCTemplateJson);
