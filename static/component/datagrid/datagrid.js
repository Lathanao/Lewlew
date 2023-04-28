import { LewElement } from '/js/LewElement.js'

import '/component/datagrid/element/datagrid-page-switcher.js'
import '/component/datagrid/element/datagrid-view-switcher.js'
import '/component/datagrid/element/datagrid-button-delete.js'
import '/component/datagrid/element/datagrid-button-export.js'
import '/component/datagrid/element/datagrid-button.js'
import '/component/datagrid/element/datagrid-modal.js'
import '/component/datagrid/element/datagrid-table.js'

export class WCDataGrid extends LewElement {
  static get observedAttributes() {
    return ['src', 'context']
  }

  // attributeChangedCallback(name, oldValue, newValue) {
  //   if (!this.__initialized) {
  //     return
  //   }
  //   if (oldValue !== newValue) {
  //     this[name] = newValue
  //   }
  // }

  constructor() {
    super()
    this.__initialized = false
    this.__template = this.getAttribute('template')
    this.__templateTbody = ''
    this.__datasource = this.getAttribute('datasource')
    this.__column = this.getAttribute('column')
    this.__data = ''
    this.__setup = ''
    this.build()

    localStorage.setItem('datagrid_template', this.__template)
    localStorage.setItem('datagrid_datasource', this.__datasource)
    localStorage.setItem('datagrid_column', this.__column)
    localStorage.setItem('datagrid_data', this.__data)
  }

  async connectedCallback() {
    let criteria = {
      uuid: '',
      criteria: {
        search: '',
        name: '',
        email: '',
        phone: '',
      },
      order: {
        by: '',
        way: '',
      },
    }

    // if (this.hasAttribute('datasource')) {
    //   await fetch(this.getAttribute('datasource'), {
    //     method: 'POST', // *GET, POST, PUT, DELETE, etc.
    //     mode: 'cors', // no-cors, *cors, same-origin
    //     cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
    //     credentials: 'same-origin', // include, *same-origin, omit
    //     headers: {
    //       'Content-Type': 'application/json',
    //       // 'Content-Type': 'application/x-www-form-urlencoded',
    //     },
    //     redirect: 'follow', // manual, *follow, error
    //     referrerPolicy: 'no-referrer', // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
    //     data: JSON.stringify(criteria), // body data type must match "Content-Type" header
    //   })
    //     .then((res) => res.json())
    //     .then((res) => (this.__data = res))
    // }

    if (this.hasAttribute('template')) {
      await fetch(this.getAttribute('template'))
        .then((res) => res.text())
        .then((res) => (this.__template = res))
    }

    if (this.hasAttribute('template_tbody')) {
      await fetch(this.getAttribute('template_tbody'))
        .then((res) => res.text())
        .then((res) => (this.__template_tbody = res))
        .then((res) =>
          localStorage.setItem('template_tbody', this.__template_tbody)
        )
    }

    if (this.hasAttribute('template_thead')) {
      await fetch(this.getAttribute('template_thead'))
        .then((res) => res.text())
        .then((res) => (this.__template_thead = res))
        .then((res) =>
          localStorage.setItem('template_thead', this.__template_thead)
        )
    }

    this.innerHTML = this.__template
  }
}

customElements.define('wc-datagrid', WCDataGrid)
class MyEvent extends Event {
  constructor(name, options, importantData) {
    super(name, options)
    this.importantData = importantData
    this.dataReceived = false
  }
  logImportantData() {}
}
