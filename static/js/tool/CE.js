//////CHAINELEMENT BY ALEX MERCED OF ALEXMERCED.COM

////////////////////////////
// getQueryHash
////////////////////////////

const getQueryHash = () => {
  const hash = window.location.href.split('#')[1]

  const queryArray1 = window.location.href.split('?')[1]

  const queryArray2 = queryArray1 ? queryArray1.split('#')[0].split('&') : []

  const queryEntries = queryArray2.map((value) => {
    return value.split('=')
  })

  return [Object.fromEntries(queryEntries), hash]
}

////////////////////////
//capture props
///////////////////////

const captureProps = (element) => {
  const att = [...element.attributes]
  const entries = att.map((value) => {
    return [value.name, value.value]
  })

  return Object.fromEntries(entries)
}

///////////////////////////
//ChainElement
//////////////////////////

class ChainElement extends HTMLElement {
  constructor(state = {}) {
    super()
    this.state = state
    this.props = captureProps(this)

    ChainElement.list.push(this)
    this.build()
  }
  static list = []
  static storage = {}
  static query = getQueryHash()[0]

  static buildAll() {
    ChainElement.list.forEach((value) => value.build())
  }

  builder(state, props, global, query) {
    return ''
  }
  postBuild(state, props, global, query) {
    return false
  }

  build() {
    this.props = captureProps(this)
    this.innerHTML = this.builder(
      this.state,
      this.props,
      ChainElement.storage,
      ChainElement.query
    )
    this.postBuild(
      this.state,
      this.props,
      ChainElement.storage,
      ChainElement.query
    )
  }

  setState(newState) {
    this.state = { ...this.state, ...newState }
    this.build()
  }
  testt() {
    console.log('test')
  }

  attach(observer) {
    this.observers.push(observer)
  }
  dettach(observer) {
    this.observers.switch(observers.indexOf(observer), 1)
  }
  notify(v) {
    console.log('observerKey ======')
    console.log(this.observers)

    for (observerKey in this.observers) {
      console.log(observerKey)
      this.observers[observerKey].update(v)
    }
  }
}
