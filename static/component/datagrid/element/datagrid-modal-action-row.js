export class DataGridModalActionRow extends HTMLElement {

  constructor () {
    super()
    this.__initialized = false
    this.__template = ''
    this.__datasource = {}
  }

  async connectedCallback () {
    this.__action = JSON.parse(this.getAttribute('action'))
    this.__template = `
    <div class="dropdown relative inline-block text-left">

    <button type="button" class="inline-flex justify-center shadow-sm px-4 py-2 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-100 focus:ring-indigo-500" id="options-menu" aria-haspopup="true" aria-expanded="true">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-dots-vertical dropbtn" width="28" height="28" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round" onclick="console.log(this)">
        <path stroke="none" d="M0 0h24v24H0z"></path>
        <circle cx="12" cy="12" r="1"></circle>
        <circle cx="12" cy="19" r="1"></circle>
        <circle cx="12" cy="5" r="1"></circle>
      </svg>
    </button>

    <div class="menu transition ease-out duration-100 transform opacity-0 scale-95 origin-top-right absolute right-0 mt-2 w-36 z-10 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 hidden">
      <div class="py-1" role="menu" aria-orientation="vertical" aria-labelledby="options-menu">`;

      Object.keys(this.__action).forEach((k, i) => {
        this.__template += `
        <a  href="` + this.__action[k] + `"
            class="block px-4 py-2 text-sm hover:bg-gray-100 hover:text-gray-900" role="menuitem">
          <i class="fad fa-eye text-xs mr-1"></i> 
          ` + k + `  
        </a>`
      });

      this.__template += `
      </div>
    </div>
    </div>`;

    this.render()

    this.addEventListener("click", function(e) {
      // this.notify('Notify')
      let menu = this.querySelector('.menu')

      if (menu.classList.contains('opacity-0')) {
          menu.classList.remove('ease-in'); 
          menu.classList.remove('duration-75'); 
          menu.classList.add('ease-out');
          menu.classList.add('duration-100');

          menu.classList.remove('opacity-0');
          menu.classList.remove('scale-95');  
          menu.classList.add('opacity-100');   
          menu.classList.add('scale-100');
      
          setTimeout(function(){ menu.classList.toggle("hidden"); }, 100);
      }else{
          menu.classList.remove('ease-in'); 
          menu.classList.remove('duration-100');
          menu.classList.add('ease-out');
          menu.classList.add('duration-75');

          menu.classList.remove('opacity-100'); 
          menu.classList.remove('scale-100');
          menu.classList.add('opacity-0');    
          menu.classList.add('scale-95'); 
          
          setTimeout(function(){ menu.classList.toggle("hidden"); }, 75);
      } 

    }.bind(this))
  }
  
  render () {
    this.innerHTML = this.__template
    this.__initialized = true
  }
}

customElements.define('wc-datagrid-modal-action-row', DataGridModalActionRow)