export class DataGridViewSwitcher extends HTMLElement {
  constructor() {
    super()
    this.__initialized = false
    this.__template = ''
    this.__datasource = {}
  }

  async connectedCallback() {
    this.__template = `
    <div class="flex items-center lg:border-r border-gray-300 pb-3 lg:pb-0 lg:px-6">
      <div class="relative w-32 z-10">
        <div class="pointer-events-none text-gray-600 dark:text-gray-400 absolute inset-0 m-auto mr-2 xl:mr-4 z-0 w-5 h-5">
          <svg xmlns="http://www.w3.org/2000/svg" class="icon cursor-pointer icon-tabler icon-tabler-chevron-down" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
            <path stroke="none" d="M0 0h24v24H0z"></path>
            <polyline points="6 9 12 15 18 9"></polyline>
          </svg>
        </div>

        <select aria-label="Selected tab" class="focus:outline-none border border-transparent focus:border-gray-800 focus:shadow-outline-gray text-base form-select block w-full py-2 px-2 xl:px-3 rounded text-gray-600 dark:text-gray-400 appearance-none bg-transparent">
          <option>List View</option>
          <option>Grid View</option>
        </select>
      </div>
    </div>`

    this.render()
  }

  render() {
    this.innerHTML = this.__template
    this.__initialized = true
  }
}

customElements.define('wc-datagrid-view-switcher', DataGridViewSwitcher)
