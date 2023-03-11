/* eslint no-undef: 0 */
import { interpolateTable } from '/js/tool/interpolateTable.js'

export class WCMenu extends HTMLElement {
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
    super()
    this.__initialized = false
    this.__template = ''
    this.__datasource = {}
    // this.__column = ['id', 'name', 'username', 'email', 'phone', 'website']
    this.__column = ['id_customer', 'firstname', 'lastname', 'email', 'passwd', 'birthday']
  }

  async connectedCallback () {

    if (this.hasAttribute('source')) {
      await fetch(this.getAttribute('source'))
      .then(res => res.json())
      .then(res => this.__datasource = res);
    }

    if (this.hasAttribute('template')) {
      await fetch(this.getAttribute('template'))
      .then(res => res.text() )
      .then(res => this.__template = res)
    }

    this.render()
  }

  render () {
    this.innerHTML = this.__template
    this.__initialized = true
  }
}

customElements.define('wc-menu', WCMenu)
