export class DatagridAction extends HTMLElement {
  constructor() {
    super()
  }

  async connectedCallback() {
    this.innerHTML = `
    <div class="grid grid-flow-col auto-cols-max">
      <div class="relative w-32 z-10">
        <div class="absolute pointer-events-none text-gray-600 inset-0 m-auto mr-2 xl:mr-4 z-0 w-5 h-5">
          <svg xmlns="http://www.w3.org/2000/svg" class="icon cursor-pointer icon-tabler icon-tabler-chevron-down" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
            <path stroke="none" d="M0 0h24v24H0z"></path>
            <polyline points="6 9 12 15 18 9"></polyline>
          </svg>
        </div>
        <select aria-label="Selected tab" class="focus:outline-none border border-transparent focus:border-gray-800 focus:shadow-outline-gray text-base form-select block w-full py-2 px-2 xl:px-3 rounded text-gray-600 appearance-none bg-transparent">
          <option value="">Select ...</option>
          <option>This page</option>
          <option>All rows</option>
          <option>Deselect</option>
        </select>
      </div>
      <datagrid-row-count></datagrid-row-count>
    </div>`
  }
}

customElements.define('wc-datagrid-action', DatagridAction)
