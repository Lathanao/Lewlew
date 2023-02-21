/* eslint no-undef: 0 */
import { interpolate } from '/js/tool/interpolate.js'

export class WCTemplate extends HTMLElement {
  static get observedAttributes () {
    return ['src', 'context']
  }
  
  attributeChangedCallback (name, oldValue, newValue) {
    if (!this.__initialized) { return }
    if (oldValue !== newValue) {
      this[name] = newValue
    }
  }

  get src () { return this.getAttribute('src') }
  set src (value) {
    this.setAttribute('src', value)
    this.setSrc()
    this.render()
  }

  get context () { return this.getAttribute('context') }
  set context (value) {
    this.setAttribute('context', value)
    this.setContext()
    this.render()
  }

  constructor () {
    console.log('constructor WCTemplate')
    super()
    this.__initialized = false
    this.__template = ''
    this.__context = {}
    console.log('End constructor WCTemplate')
  }

  async connectedCallback () {
    console.log('Start connectedCallback WCTemplate')
    if (this.hasAttribute('src')) {
      await this.setSrc()
    }

    console.log('Mid connectedCallback WCTemplate')
    if (this.hasAttribute('context')) {
      console.log('this.hasAttribute WCTemplate')
      await this.setContext()
    }
    console.log('MidMid connectedCallback WCTemplate')

    this.render()
    this.__initialized = true
    console.log('End connectedCallback WCTemplate')
  }

  async setSrc () {
    const path = this.getAttribute('src')
    this.__template = await this.fetchSrc(path)
  }

  async fetchSrc (src) {
    const response = await fetch(src)
    if (response.status !== 200) throw Error(`ERR ${response.status}: ${response.statusText}`)
    return response.text()
  }

  async setContext () {
    console.log(this.getAttribute('context'))
    const path = this.getAttribute('context')
    this.__context = await this.fetchContext(path)
  }

  async fetchContext (src) {
    const response = await fetch(src)
    if (response.status !== 200) throw Error(`ERR ${response.status}: ${response.statusText}`)
    return response.json()
  }

  render () {
    this.innerHTML = interpolate(this.__template, this.__context)
  }
}

customElements.define('wc-template', WCTemplate)
