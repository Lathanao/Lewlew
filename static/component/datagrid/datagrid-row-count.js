export class LewDatagridRowCount extends HTMLElement {

  constructor() {
    super()
    this.__initialized = false
    this.__template = ''
    this.__templateTbody = ''
    this.__datasource = ''
    this.__column = ''
    this.__data = ''
    this.__setup = ''
    this.__datasetup = ''
    this.build()
  }

  async connectedCallback() {
    this.__datasource = localStorage.setItem('datasource') + '/count'
    await fetch(this.__datasource)
    .then((res) => res.text())
    .then((res) =>
      localStorage.setItem('template_thead', this.__template_thead)
    )

    let count = 111
    this.innerHTML = `
    <p class="block w-full py-2 px-2 xl:px-3 text-gray-600 dark:text-gray-400 appearance-none leading-normal">
       $(count) records found
    </p>`
  }
}

customElements.define('lew-datagrid-row-count', LewDatagridRowCount)
