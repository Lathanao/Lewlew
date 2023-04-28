import { LewElement } from '/js/LewElement.js'

export class DatagridPageSwitcher extends LewElement {
  constructor() {
    super()
    console.log('DatagridPageSwitcher constructor')
    this.__initialized = false
    this.__template = ''
    this.__datasource = localStorage.getItem('datagrid_datasource')
    this.__event = ''
    this.__count = ''

    this.__startpage = 1
    this.__rowsbypage = 1

    this.__defaulttext = 'Viewing 1 - 20 of 60'
    this.__template = `
  <div class="w-full flex flex-col lg:flex-row items-start lg:items-center justify-end">
  <div class="flex items-center lg:border-l lg:border-r border-gray-300 py-3 lg:py-0 lg:px-6">
    <div class="w-full flex flex-col lg:flex-row items-start lg:items-center">
      <div class="flex items-center">
        <p class="text-base text-gray-600 dark:text-gray-400" id="page-view">${this.__defaulttext}</p>
        
        <a class="text-gray-600 dark:text-gray-400 mx-4 p-2 border-transparent border bg-gray-100 dark:hover:bg-gray-600 dark:bg-gray-700 hover:bg-gray-200 cursor-pointer rounded focus:outline-none focus:border-gray-800 focus:shadow-outline-gray">
          <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-chevron-left" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
            <path stroke="none" d="M0 0h24v24H0z"></path>
            <polyline points="15 6 9 12 15 18"></polyline>
          </svg>
        </a>
        
        <a class="text-red-500 p-2 border-transparent border bg-gray-100 dark:bg-gray-700 dark:hover:bg-gray-600 hover:bg-gray-200 cursor-pointer rounded focus:outline-none focus:border-gray-800 focus:shadow-outline-gray">
          <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-chevron-right" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
            <path stroke="none" d="M0 0h24v24H0z"></path>
            <polyline points="9 6 15 12 9 18"></polyline>
          </svg>
        </a>
      </div>
    </div>
  </div>
  
  <div class="flex items-center lg:border-r border-gray-300 pb-3 lg:pb-0 lg:px-6">
    <div class="relative w-20 z-10">
      <div class="pointer-events-none text-gray-600 dark:text-gray-400 absolute inset-0 m-auto mr-2 xl:mr-4 z-0 w-5 h-5">
        <svg xmlns="http://www.w3.org/2000/svg" class="icon cursor-pointer icon-tabler icon-tabler-chevron-down" width="20" height="20" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
          <path stroke="none" d="M0 0h24v24H0z"></path>
          <polyline points="6 9 12 15 18 9"></polyline>
        </svg>
      </div>

      <select aria-label="Selected tab" class="focus:outline-none border border-transparent focus:border-gray-800 focus:shadow-outline-gray text-base form-select block w-full py-2 px-2 xl:px-3 rounded text-gray-600 dark:text-gray-400 appearance-none bg-transparent">
        <option>10</option>
        <option>20</option>
        <option>50</option>
        <option>100</option>
        <option>200</option>
        <option>500</option>
        <option>1000</option>
      </select>
    </div>
  </div></div>
  `
    this.innerHTML = this.__template
    let set_text = function (el) {
      el.classList.remove('transform')
      el.classList.remove('rotate-180')
      el.classList.remove('ease-in')
      el.classList.remove('duration-75')
      el.classList.add('opacity-0')
    }
  }

  async connectedCallback() {
    let buttonPageView = this.querySelectorAll('a')

    buttonPageView.forEach((Value, index, obj) => {
      buttonPageView[index].addEventListener('click', function (event) {
        event.preventDefault()

        if (event.target.getAttribute('type') == 'plus') {
          this.__startpage = this.__startpage + 1
        } else if (
          event.target.getAttribute('type') == 'minnus' &&
          this.__startpage > 1
        ) {
          this.__startpage = this.__startpage - 1
        }
      })
    })
  }

  async connectadoptedCallbackedCallback() {}

  // async get_count() {
  //   await fetch(this.__datasource + '/setup', {
  //     method: 'GET', // *GET, POST, PUT, DELETE, etc.
  //     mode: 'cors', // no-cors, *cors, same-origin
  //     cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
  //     credentials: 'same-origin', // include, *same-origin, omit
  //     headers: {
  //       'Content-Type': 'application/json',
  //       // 'Content-Type': 'application/x-www-form-urlencoded',
  //     },
  //     redirect: 'follow', // manual, *follow, error
  //     referrerPolicy: 'no-referrer', // body data type must match "Content-Type" header
  //   })
  //     .then((res) => res.json())
  //     .then((res) => (this.__count = res))
  // }
}

customElements.define('wc-datagrid-page-switcher', DatagridPageSwitcher)
