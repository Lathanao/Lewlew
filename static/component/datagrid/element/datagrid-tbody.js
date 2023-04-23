import { interpolateRow } from '/js/tool/interpolateRow.js'

export class DataGridTbody extends HTMLElement {
  constructor() {
    super()
    this.__initialized = false
    this.__template = ''
    this.__datasource = {}

    this.__template = localStorage.getItem('datagrid__template')
    this.__datasource = localStorage.getItem('datagrid__datasource')
    this.__column = localStorage.getItem('datagrid__column')
    this.__data = localStorage.getItem('datagrid__data')
    this.build()
    this.subscribe('datagrid-update-tbody')
  }

  async connectedCallback() {
    this.__action = JSON.parse(this.getAttribute('action'))

    await fetch('/backend/datagrid-tbody.html')
      .then((res) => res.text())
      .then((res) => (this.__templateTbody = res))

    this.innerHTML = interpolateRow(this.__templateTbody, this.__data)
    this.update()
  }

  async update() {
    let payload = {
      uuid: '',
      criteria: {
        search: '',
        name: '',
        email: '',
        phone: '',
      },
      order: {
        by: Storage.filter.order.by,
        way: Storage.filter.order.way,
      },
    }

    var data = new FormData()
    data.append('json', JSON.stringify(payload))

    if (this.__datasource !== 'undefined') {
      await fetch(this.__datasource, {
        method: 'POST', // *GET, POST, PUT, DELETE, etc.
        mode: 'cors', // no-cors, *cors, same-origin
        cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
        credentials: 'same-origin', // include, *same-origin, omit
        headers: {
          'Content-Type': 'application/json', // 'Content-Type': 'application/x-www-form-urlencoded',
        },
        redirect: 'follow', // manual, *follow, error
        referrerPolicy: 'no-referrer', // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
        body: JSON.stringify(payload), // body data type must match "Content-Type" header
      })
        .then((res) => res.json())
        .then((res) => (this.__data = res))
    }

    let tbody = interpolateRow(this.__templateTbody, this.__data)

    this.innerHTML = interpolateRow(this.__templateTbody, this.__data)
  }

  async connectedCallback() {
    console.log('connectedCallback from tbody')
    this.render()
  }
}

customElements.define('wc-datagrid-tbody', DataGridTbody)
