const initialState = {};


export class LewElement extends HTMLElement {

  constructor() {
    super(initialState);
    // this.observers = [];
    // this.storage = {};
  }

  create(state, props, global, query) {
    return '';
  }
  update(state, props, global, query) {
    return false;
  }

  static list = [];

  build() {
      this.innerHTML = this.create(
          this.state,
          this.props,
          LewElement.storage,
          LewElement.query
      );
  }

  attach(observer) {
    LewElement.observers.push(observer);
  };
  
  dettach(observer) {
    LewElement.observers.switch(LewElement.observers.indexOf(observer), 1);
  };

  notify(v) {
    LewElement.observers.forEach((value) => value.update(v));
  }
}
