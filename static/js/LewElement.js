const initialState = {}

export class LewElement extends HTMLElement {
  constructor() {
    super(initialState)
  }

  create(state, props, storage, query) {
    return ''
  }
  update(state, props, storage, query) {}

  static list = []

  build() {
    this.innerHTML = this.create(
      this.state,
      this.props,
      Storage.storage,
      Storage.query
    )
  }

  render() {
    this.innerHTML = interpolateTable(
      this.__template,
      this.__data,
      this.__column
    )
    this.__initialized = true
  }

  attach(observer) {
    Storage.observers.push(observer)
  }

  dettach(observer) {
    Storage.observers.switch(LewElement.observers.indexOf(observer), 1)
  }

  notify(data) {
    Storage.observers.forEach((HTMLElement) => HTMLElement.update(data))
  }

  subscribe(event) {
    if (typeof Storage.event[event] === 'undefined') {
      Storage.event[event] = []
    }
    Storage.event[event].push(this)
  }

  dispatch(event, data) {
    console.log('dispatch: ' + event)
    Storage.event[event].forEach((HTMLElement) => {
      HTMLElement.update(data)
    })
  }
}
