import { interpolateRow } from '/js/tool/interpolateRow.js'
import { interpolate } from '/js/tool/interpolate.js'
import { LewElement } from '/js/LewElement.js'

class DataGridTable extends LewElement {
  constructor() {
    super()

    this.__datasource = localStorage.getItem('datagrid__datasource')
    this.__template = localStorage.getItem('datagrid__template_tbody')
    this.__column = localStorage.getItem('datagrid__column')
    this.__data = localStorage.getItem('datagrid__data')

    if (typeof Storage.event['datagrid-table-update-grid'] === 'undefined') {
      Storage.event['datagrid-table-update-grid'] = []
    }
    Storage.event['datagrid-table-update-grid'].push(this)
  }

  async connectedCallback() {
    let table = `
    <table id='datagrid-table' class="min-w-full bg-white dark:bg-gray-800">
      <thead></thead>
      <tbody></tbody>
    </table>`

    this.innerHTML = table
    this.add_header()
    // this.update()
  }

  async add_header() {
    let thead = this.getElementsByTagName('thead')[0]
    let headervalues = []
    localStorage
      .getItem('datagrid_column')
      .slice(1, -1)
      .replace(/\s/g, '')
      .split(',')
      .forEach((row) => {
        headervalues.push(row.charAt(0).toUpperCase() + row.slice(1))
      })

    thead.innerHTML = interpolate(localStorage.getItem('template_thead'), {
      header: headervalues,
    })

    thead.onclick = (el) => {
      Array.from(el.target.children).forEach((child) => {
        if (child instanceof HTMLImageElement) {
          toggle_carret(child)
          this.dispatch('datagrid-table-update-grid', {})
        }
      })
    }

    let toggle_carret = function (el) {
      if (el.classList.contains('opacity-0')) {
        hide_all_carret(el)
        el.classList.remove('opacity-0')
      } else if (el.classList.contains('rotate-180')) {
        el.classList.remove('transform')
        el.classList.remove('rotate-180')
      } else {
        el.classList.add('ease-in')
        el.classList.add('duration-100')
        el.classList.add('transform')
        el.classList.add('rotate-180')
      }
    }

    let hide_all_carret = function (el) {
      let all_img = el.closest('tr').getElementsByTagName('img')
      Array.from(all_img).forEach((img) => {
        hide_carret(img)
      })
    }

    let hide_carret = function (el) {
      el.classList.remove('transform')
      el.classList.remove('rotate-180')
      el.classList.remove('ease-in')
      el.classList.remove('duration-75')
      el.classList.add('opacity-0')
    }
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

    let tbody = this.getElementsByTagName('tbody')[0]
    tbody.innerHTML = interpolate(localStorage.getItem('template_tbody'), {
      cells: this.__data,
    })
  }
}

customElements.define('wc-datagrid-table', DataGridTable)

class WordCount extends HTMLParagraphElement {
  constructor() {
    // Always call super first in constructor
    super()

    this.innerHTML = 'WordCount = 9'
  }
}

// Define the new element
customElements.define('word-count', WordCount, { extends: 'p' })
