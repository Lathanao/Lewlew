import { LewElement } from "/js/LewElement.js";

export class WCEventInput extends LewElement {
  constructor() {
    super();
    this.build();
    this.subscribe('up-from-button')
  }

  create(state, props, storage, query) {

    const template = `<input id="event-input" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"/>`;

    return template;
  }

  update(state, props, storage, query) {
    this.innerHTML = '<input value="Updated!" id="event-input" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"/>'
  }
}

customElements.define("wc-event-input", WCEventInput);
