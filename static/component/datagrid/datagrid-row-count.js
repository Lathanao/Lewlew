export class LewDatagridRowCount extends HTMLElement {

  constructor() {
    super()
    this.__datasource = ''
    this.__count = ''
  }

  async connectedCallback() {

    this.__datasource = localStorage.getItem('datagrid_datasource') + '/count'
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
      body: '', // body data type must match "Content-Type" header
    })
    .then((res) => res.json())
    .then((res) => this.__count = res.count)

    this.innerHTML = '<span class="block text-gray-600 w-full p-2 xl:px-3">Total of ' + this.__count + ' records found  </span>'
  }
}

customElements.define('lew-datagrid-row-count', LewDatagridRowCount)
