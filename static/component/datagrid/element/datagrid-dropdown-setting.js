import { LewElement } from '/js/LewElement.js'
import { WCHello } from '/component/wc-hello.js'
export class LewDatagridDropdownSetting extends LewElement {
  constructor() {
    super()
    this.build()
  }

  create(state, props, storage, query) {
    const template = `
<div class="relative">
  <a class="block text-gray-600 dark:text-gray-400 mx-2 p-2 border-transparent border bg-gray-100 dark:hover:bg-gray-600 dark:bg-gray-700 hover:bg-gray-200 cursor-pointer rounded focus:outline-none focus:border-gray-800 focus:shadow-outline-gray"
    href="javascript: void(0)">
    <svg xmlns="http://www.w3.org/2000/svg" class="icon cursor-pointer icon-tabler icon-tabler-settings" width="20"
      height="20" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" fill="none" stroke-linecap="round"
      stroke-linejoin="round">
      <path stroke="none" d="M0 0h24v24H0z"></path>
      <path
        d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 0 0 2.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 0 0 1.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 0 0 -1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 0 0 -2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 0 0 -2.573 -1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 0 0 -1.065 -2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 0 0 1.066 -2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z">
      </path>
      <circle cx="12" cy="12" r="3"></circle>
    </svg>
    <div
      class="menu-dropdown-setting transition ease-out duration-100 transform opacity-0 scale-95 origin-top-right absolute right-0 mt-2 w-36 z-10 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 hidden">
      <div>
        <div class="text-xs font-semibold text-slate-400 uppercase pt-1.5 pb-2 px-4">Filters</div>
        <ul class="mb-4">
          <li class="py-1 px-3"><label class="flex items-center"><input type="checkbox" class="form-checkbox"><span
                class="text-sm font-medium ml-2">Direct VS Indirect</span></label></li>
          <li class="py-1 px-3"><label class="flex items-center"><input type="checkbox" class="form-checkbox"><span
                class="text-sm font-medium ml-2">Real Time Value</span></label></li>
          <li class="py-1 px-3"><label class="flex items-center"><input type="checkbox" class="form-checkbox"><span
                class="text-sm font-medium ml-2">Top Channels</span></label></li>
          <li class="py-1 px-3"><label class="flex items-center"><input type="checkbox" class="form-checkbox"><span
                class="text-sm font-medium ml-2">Sales VS Refunds</span></label></li>
          <li class="py-1 px-3"><label class="flex items-center"><input type="checkbox" class="form-checkbox"><span
                class="text-sm font-medium ml-2">Last Order</span></label></li>
          <li class="py-1 px-3"><label class="flex items-center"><input type="checkbox" class="form-checkbox"><span
                class="text-sm font-medium ml-2">Total Spent</span></label></li>
        </ul>
        <div class="py-2 px-3 border-t border-slate-200 bg-slate-50">
          <ul class="flex items-center justify-between">
            <li><button
                class="btn-xs bg-white border-slate-200  text-slate-500 hover:text-slate-600 hover:bg-grey-300 text-sm">Clear</button>
            </li>
            <li><button class="btn-xs py-1 px-2 rounded bg-indigo-500 hover:bg-indigo-700 hover:bg-indigo-600 text-white text-sm">Apply</button></li>
          </ul>
        </div>
      </div>
    </div>
  </a>
</div>`

    return template
  }

  async connectedCallback() {
    this.addEventListener(
      'click',
      function (e) {
        // this.notify('Notify')
        let menu = this.querySelector('.menu-dropdown-setting')

        if (menu.classList.contains('opacity-0')) {
          menu.classList.remove('ease-in')
          menu.classList.remove('duration-75')
          menu.classList.add('ease-out')
          menu.classList.add('duration-100')

          menu.classList.remove('opacity-0')
          menu.classList.remove('scale-95')
          menu.classList.add('opacity-100')
          menu.classList.add('scale-100')

          setTimeout(function () {
            menu.classList.toggle('hidden')
          }, 100)
        } else {
          menu.classList.remove('ease-in')
          menu.classList.remove('duration-100')
          menu.classList.add('ease-out')
          menu.classList.add('duration-75')

          menu.classList.remove('opacity-100')
          menu.classList.remove('scale-100')
          menu.classList.add('opacity-0')
          menu.classList.add('scale-95')

          setTimeout(function () {
            menu.classList.toggle('hidden')
          }, 75)
        }
      }.bind(this)
    )

    this.getElem
    button
  }
}

customElements.define(
  'lew-datagrid-dropdown-setting',
  LewDatagridDropdownSetting
)
