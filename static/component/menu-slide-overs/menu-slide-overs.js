/* eslint no-undef: 0 */
import { interpolateTable } from '/js/tool/interpolateTable.js'

import '/component/datagrid/element/wc-datagrid-view-switcher.js'
import '/component/datagrid/element/wc-datagrid-button-delete.js'
import '/component/datagrid/element/wc-datagrid-button.js'
import '/component/datagrid/element/wc-datagrid-pageview.js'

export class WCDataGrid extends HTMLElement {
  static get observedAttributes() {
    return ['src', 'context']
  }

  attributeChangedCallback(name, oldValue, newValue) {
    if (!this.__initialized) {
      return
    }
    if (oldValue !== newValue) {
      this[name] = newValue
    }
  }

  get src() {
    return this.getAttribute('src')
  }
  set src(value) {
    this.setAttribute('src', value)
    this.setSrc()
    this.render()
  }

  get context() {
    return this.getAttribute('context')
  }
  set context(value) {
    this.setAttribute('context', value)
    this.setContext()
    this.render()
  }

  constructor() {
    super()
    this.__initialized = false
    this.__template = this.getAttribute('template')
    this.__datasource = this.getAttribute('datasource')
    this.__column = this.getAttribute('column')
    this.__data = ''
  }

  async connectedCallback() {
    let payload = {
      uuid: '',
      criteria: {
        search: '',
        name: '',
        email: '',
        phone: '',
      },
    }

    if (this.hasAttribute('datasource')) {
      await fetch(this.getAttribute('datasource'), {
        method: 'POST', // *GET, POST, PUT, DELETE, etc.
        mode: 'cors', // no-cors, *cors, same-origin
        cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
        credentials: 'same-origin', // include, *same-origin, omit
        headers: {
          'Content-Type': 'application/json',
          // 'Content-Type': 'application/x-www-form-urlencoded',
        },
        redirect: 'follow', // manual, *follow, error
        referrerPolicy: 'no-referrer', // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
        body: JSON.stringify(payload), // body data type must match "Content-Type" header
      })
        .then((res) => res.json())
        .then((res) => (this.__data = res))
    }

    if (this.hasAttribute('template')) {
      await fetch(this.getAttribute('template'))
        .then((res) => res.text())
        .then((res) => (this.__template = res))
    }

    this.render()
  }

  render() {
    this.innerHTML = interpolateTable(
      this.__template,
      this.__data,
      this.__column
    )
    this.__initialized = true
  }
}

customElements.define('wc-datagrid', WCDataGrid)
