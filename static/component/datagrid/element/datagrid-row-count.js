export class DatagridRowCount extends HTMLElement {
  constructor() {
    super()
    this.__datasource = {}
  }

  async connectedCallback() {
    this.innerHTML = `
    <p class="block w-full py-2 px-2 xl:px-3 text-gray-600 dark:text-gray-400 appearance-none leading-normal">
      18543 records found
    </p>`
  }
}

customElements.define('datagrid-row-count', DatagridRowCount)
