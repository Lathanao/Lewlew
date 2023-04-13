/* eslint no-undef: 0 */
import { interpolateTable } from "/js/tool/interpolateTable.js";
import { LewElement } from "/js/LewElement.js";

import "/component/datagrid/element/datagrid-view-switcher.js";
import "/component/datagrid/element/datagrid-button-delete.js";
import "/component/datagrid/element/datagrid-button.js";
import "/component/datagrid/element/datagrid-pageview.js";
import "/component/datagrid/element/datagrid-modal-action-row.js";

LewElement.observers = [];
LewElement.storage = {};
LewElement.storage.bank = "Bank works well";
LewElement.storage.label = "Push the button";
LewElement.storage.filter = [];
export class WCDataGrid extends LewElement {
  static get observedAttributes() {
    return ["src", "context"];
  }

  static storage = {};

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

  async update() {
    console.log("updated");
  }

  constructor() {
    super();
    this.__initialized = false;
    this.__template = this.getAttribute("template");
    this.__datasource = this.getAttribute("datasource");
    this.__column = this.getAttribute("column");
    this.__data = "";

    // this.addEventListener('event-datagrid-button', this.handleDone);
    // this.addEventListener('done', this.handleDone);

    // this.addEventListener('kick', function (e) {
    //   console.log('get event');
    //   console.log(e.detail.kicked); // true
    // })

    const customEvent = new MyEvent(
      "custom-event",
      {
        bubbles: true,
      },
      "Something important"
    );

    this.addEventListener("click", (e) => {
      console.log("Click on: ", e.target);
      this.dispatchEvent(
        new Event("checkup", {
          bubbles: true,
        })
      );
      this.dispatchEvent(customEvent);

      Array.from(e.target.children).forEach(child => {
        if (child instanceof HTMLImageElement) {
          toggle_carret(child);
        }
      })
    });


    let toggle_carret = function (el) {
      LewElement.observers.forEach((value) => hide_carret(v));

      if (el.classList.contains("opacity-0")) {
        hide_all_carret(el)
        el.classList.remove("opacity-0");
      } else if (el.classList.contains("rotate-180")) {
        el.classList.remove("transform");
        el.classList.remove("rotate-180");
      } else {
        el.classList.add("ease-in");
        el.classList.add("duration-100");
        el.classList.add("transform");
        el.classList.add("rotate-180");
      }
    };

    let hide_carret = function (el) {
      el.classList.remove("transform");
      el.classList.remove("rotate-180");
      el.classList.remove("ease-in");
      el.classList.remove("duration-75");
      el.classList.add("opacity-0");
    };

    let hide_all_carret = function (el) {
      let all_img = el.closest('tr').getElementsByTagName('img')
      Array.from(all_img).forEach(img => {
        hide_carret(img)
      })
    };
  }

  async connectedCallback(storage) {
    let payload = {
      uuid: "",
      criteria: {
        search: "",
        name: "",
        email: "",
        phone: "",
      },
      order: {
        by: storage.filter,
        way: ""
      },
    };

    if (this.hasAttribute("datasource")) {
  
      await fetch(this.getAttribute("datasource"), {
        method: "POST", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, *cors, same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "same-origin", // include, *same-origin, omit
        headers: {
          "Content-Type": "application/json",
          // 'Content-Type': 'application/x-www-form-urlencoded',
        },
        redirect: "follow", // manual, *follow, error
        referrerPolicy: "no-referrer", // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
        body: JSON.stringify(payload), // body data type must match "Content-Type" header
      })
        .then((res) => res.json())
        .then((res) => (this.__data = res));
    }

    // await fetch("https://jsonplaceholder.typicode.com/users")
    // .then(res => res.json())
    // .then(res => this.__datasource = res);

    // if (this.hasAttribute('column')) {
    //   await fetch(this.getAttribute('column'))
    //   .then(res => res.text())
    //   .then(res => this.column = res);
    // }

    if (this.hasAttribute("template")) {
      await fetch(this.getAttribute("template"))
        .then((res) => res.text())
        .then((res) => (this.__template = res));
    }

    this.render();
  }

  render() {
    this.innerHTML = interpolateTable(
      this.__template,
      this.__data,
      this.__column
    );
    this.__initialized = true;
  }
}

customElements.define("wc-datagrid", WCDataGrid);
class MyEvent extends Event {
  constructor(name, options, importantData) {
    super(name, options);
    this.importantData = importantData;
    this.dataReceived = false;
  }
  logImportantData() {
    console.log(this.importantData);
  }
}
