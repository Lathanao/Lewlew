export class DataGridButtonExport extends HTMLElement {
  constructor() {
    super()
    this.__template = ''
  }

  async connectedCallback() {
    this.__template = `
    <div class="flex items-center lg:border-r border-gray-300 pb-3 lg:pb-0 lg:px-6">
      <div class="flex items-center">
        <a class="text-gray-600 dark:text-gray-400 p-2 border-transparent border bg-gray-100 dark:hover:bg-gray-600 dark:bg-gray-700 hover:bg-gray-200 cursor-pointer rounded focus:outline-none focus:border-gray-800 focus:shadow-outline-gray" href="javascript: void(0)">
          <svg xmlns="http://www.w3.org/2000/svg" class="icon cursor-pointer icon-tabler icon-tabler-edit" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
            <path stroke="none" d="M0 0h24v24H0z"></path>
            <path d="M9 7 h-3a2 2 0 0 0 -2 2v9a2 2 0 0 0 2 2h9a2 2 0 0 0 2 -2v-3"></path>
            <path d="M9 15h3l8.5 -8.5a1.5 1.5 0 0 0 -3 -3l-8.5 8.5v3"></path>
            <line x1="16" y1="5" x2="19" y2="8"></line>
          </svg>
        </a>
      </div>
    </div>`

    this.innerHTML = this.__template
  }
}

customElements.define('wc-datagrid-export', DataGridButtonExport)
