import { LewElement } from '/js/LewElement.js'

export class LewDashboardMessage extends LewElement {
  constructor() {
    super()
    this.build()
    this.buildChart()
  }

  create(state, props, storage, query) {
    const template = `
<div class="shadow-lg rounded-2xl p-4 w-full">
  <p class="font-bold text-md text-black">
    Messages
  </p>
  <ul>
    <li class="flex items-center my-6 space-x-2">
      <a href="#" class="block relative">
        <img alt="profil" src="/image/man.png" class="mx-auto object-cover rounded-full h-10 w-10 ">
      </a>
      <div class="flex flex-col">
        <span class="text-sm text-gray-900 font-semibold ml-2">
          Charlie Rabiller
        </span>
        <span class="text-sm text-gray-400 ml-2">
          Hey John ! Do you read the NextJS doc ?
        </span>
      </div>
    </li>
    <li class="flex items-center my-6 space-x-2">
      <a href="#" class="block relative">
        <img alt="profil" src="/image/man.png" class="mx-auto object-cover rounded-full h-10 w-10 ">
      </a>
      <div class="flex flex-col">
        <span class="text-sm text-gray-900 font-semibold ml-2">
          Marie Lou
        </span>
        <span class="text-sm text-gray-400 ml-2">
          No I think the dog is better...
        </span>
      </div>
    </li>
    <li class="flex items-center my-6 space-x-2">
      <a href="#" class="block relative">
        <img alt="profil" src="/image/man.png" class="mx-auto object-cover rounded-full h-10 w-10 ">
      </a>
      <div class="flex flex-col">
        <span class="text-sm text-gray-900 font-semibold ml-2">
          Ivan Buck
        </span>
        <span class="text-sm text-gray-400 ml-2">
          Seriously ? haha Bob is not a children !
        </span>
      </div>
    </li>
    <li class="flex items-center my-6 space-x-2">
      <a href="#" class="block relative">
        <img alt="profil" src="/image/man.png" class="mx-auto object-cover rounded-full h-10 w-10 ">
      </a>
      <div class="flex flex-col">
        <span class="text-sm text-gray-900 font-semibold ml-2">
          Marina Farga
        </span>
        <span class="text-sm text-gray-400 ml-2">
          Do you need that deisgn ?
        </span>
      </div>
    </li>
  </ul>
</div>`

    return template
  }

  buildChart() {}
}

customElements.define('lew-dashboard-message', LewDashboardMessage)
