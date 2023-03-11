export class PageView extends HTMLElement {

  constructor () {
    super()
    this.__initialized = false
    this.__template = ''
    this.__datasource = {}
    this.__event = ''
  }

  async connectedCallback () {

    this.__template = `        
    <p class="text-base text-gray-600 dark:text-gray-400" id="page-view">Viewing 1 - 20 of 60</p>
    <a class="text-gray-600 dark:text-gray-400 ml-2 border-transparent border cursor-pointer rounded"
  onclick="{headerClicked}">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-chevron-left" width="20"
        height="20" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" fill="none" stroke-linecap="round"
        stroke-linejoin="round">
        <path stroke="none" d="M0 0h24v24H0z"></path>
        <polyline points="15 6 9 12 15 18"></polyline>
      </svg>
    </a>
    <a class="text-gray-600 dark:text-gray-400 border-transparent border rounded focus:outline-none cursor-pointer"
      onclick="pageView(true)">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-chevron-right" width="20"
        height="20" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" fill="none" stroke-linecap="round"
        stroke-linejoin="round">
        <path stroke="none" d="M0 0h24v24H0z"></path>
        <polyline points="9 6 15 12 9 18"></polyline>
      </svg>
    </a>`;

    this.render()
  }
  
  headerClicked (e) {
    console.log('clicked')
    this.render()
  }

  render () {
    this.innerHTML = this.__template
    this.__initialized = true



    let buttonList = this.querySelectorAll('a');

    buttonList.forEach((Value, index, obj) => {
      openmodal[index].addEventListener('click', function (event) {
        event.preventDefault()
        __doSomething(event)
        console.log('click action button')
      }); 
    },'biding');
  }

  async connectadoptedCallbackedCallback () {
    console.log('adopted')
  }
}

customElements.define('wc-datagrid-pageview', PageView)