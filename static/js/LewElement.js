const initialState = {};


export class LewElement extends HTMLElement {
  constructor() {
    super(initialState);
    this.observers = [];
    this.storage = {};

    // this.attach = function (observer) {
    //   this.observers.push(observer);
    // };
    // this.dettach = function (observer) {
    //   this.observers.switch(observers.indexOf(observer), 1);
    // };
    // this.notify = function (v) {
    //   console.log('observerKey ======')
    //   console.log(this.observers)

    //   console.log(this.observers['wc-datagrid'])
      
    //   for (observerKey in this.observers) {
    //     console.log(observerKey)
    //     this.observers[observerKey].update(v);
    //   }
    // };
  }
}
