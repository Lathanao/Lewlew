import { interpolate } from '/js/tool/interpolate.js'
import { LewElement } from '/js/LewElement.js'

class DataGridTable extends LewElement {
  constructor() {
    super()

    this.__datasource = localStorage.getItem('datagrid_datasource')
    this.__template = localStorage.getItem('datagrid_template_tbody')
    this.__column = localStorage.getItem('datagrid_column')
    this.__data = localStorage.getItem('datagrid_data')

    // if (typeof Storage.event['datagrid-table-update-grid'] === 'undefined') {
    //   Storage.event['datagrid-table-update-grid'] = []
    // }
    // Storage.event['datagrid-table-update-grid'].push(this)

    this.subscribe('datagrid-table-update-grid')
  }

  async connectedCallback() {
    let table = `
    <table id='datagrid-table' class="min-w-full">
      <thead class="sticky bg-gray-100 top-0 z-100"></thead>
      <tbody></tbody>
    </table>`

    this.innerHTML = table
    this.add_header()
    this.update()
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
        // headervalues.push(row.charAt(0).toUpperCase() + row.slice(1))
        headervalues.push(row)
      })

    await fetch(this.__datasource + '/column', {
      method: 'POST', // *GET, POST, PUT, DELETE
      mode: 'cors', // no-cors, *cors, same-origin
      cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
      credentials: 'same-origin', // include, *same-origin, omit
      headers: {
        'Content-Type': 'application/json', // 'Content-Type': 'application/x-www-form-urlencoded',
      },
      redirect: 'follow', // manual, *follow, error
      referrerPolicy: 'no-referrer', // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
      body: '', // body data type must match "Content-Type" header
    })
      .then((res) => res.json())
      .then((res) => {
        // console.log(res)
        thead.innerHTML = interpolate(localStorage.getItem('template_thead'), {
          header: Object.values(res),
        })

        thead.onclick = (ev) => {
          Array.from(ev.target.children).forEach((child) => {
            if (child instanceof HTMLImageElement) {
              console.log(child)
              toggle_carret(child)
              set_filter_by_element(child)
              this.dispatch('datagrid-table-update-grid', {})
            }
          })
        }

        let toggle_carret = function (el) {
          if (el.classList.contains('opacity-0')) {
            reset_filters()
            hide_all_carret(el)
            el.setAttribute('way', 'DESC')
            el.classList.remove('opacity-0')
          } else if (el.classList.contains('rotate-180')) {
            el.setAttribute('way', 'DESC')
            el.classList.remove('transform')
            el.classList.remove('rotate-180')
          } else {
            el.setAttribute('way', 'ASC')
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

        let reset_filters = function (el) {
          localStorage.setItem('datagrid_order_filter_attribute', '')
          localStorage.setItem('datagrid_order_filter_way', '')
          localStorage.setItem('datagrid_order_criteria', '')
        }

        let set_filter_by_element = function (el) {
          console.log('======' + el.getAttribute('attr_order'))
          console.log('======' + el.getAttribute('attr_order'))
          localStorage.setItem(
            'datagrid_order_filter_attribute',
            el.parentNode.getAttribute('filter')
          )
          localStorage.setItem(
            'datagrid_order_filter_way',
            el.getAttribute('way')
          )
        }
      })
  }

  async update(data) {
    // console.log('========== Update DataGridTable with: ' + data + ' ==========')
    // let payload = {
    //   uuid: '',
    //   criteria_search: '',
    //   criteria_name: '',
    //   criteria_email: '',
    //   criteria_phone: '',
    //   order_attribute: localStorage.getItem('datagrid_order_filter_attribute'),
    //   order_way: localStorage.getItem('datagrid_order_filter_way'),
    // }

    // jsonq := '{"where": [{"attr": "one", "value": "two"},{"attr": "attr", "value": "3"}],
    // 					 "orderby": {"attr": "id_product", "way": "DESC"},
    // 					 "pagelimit": {"page": "10", "number": "20"}}'

    let criteria = {
      where: [
        {
          attr: '',
          value: '',
        },
      ],
      orderby: {
        attr: localStorage.getItem('datagrid_order_filter_attribute'),
        way: localStorage.getItem('datagrid_order_filter_way'),
      },
      limit: {
        currentpage: localStorage.getItem('datagrid_order_limit_currentpage'),
        rowsbypage: localStorage.getItem('datagrid_order_limit_rowsbypage'),
      },
    }

    // console.log(criteria)

    if (this.__datasource !== 'undefined') {
      await fetch(this.__datasource, {
        method: 'POST', // *GET, POST, PUT, DELETE
        mode: 'cors', // no-cors, *cors, same-origin
        cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
        credentials: 'same-origin', // include, *same-origin, omit
        headers: {
          'Content-Type': 'application/json', // 'Content-Type': 'application/x-www-form-urlencoded',
        },
        redirect: 'follow', // manual, *follow, error
        referrerPolicy: 'no-referrer', // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
        body: JSON.stringify(criteria), // body data type must match "Content-Type" header
      })
        .then((res) => res.json())
        .then((res) => (this.__data = res))
    }
    // console.log(this.__data)
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
