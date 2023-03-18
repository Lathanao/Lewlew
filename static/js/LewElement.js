const initialState = {};


export class LewElement extends HTMLElement {
  constructor() {
    super(initialState);
    this.observers = [];
    this.storage = {};
  }


}
