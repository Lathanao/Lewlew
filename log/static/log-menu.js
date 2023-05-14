import { LewElement } from '/js/LewElement.js'
import { interpolate } from '/js/tool/interpolate.js'

export class LewLogMenu extends LewElement {
  constructor() {
    super()
    this.__datasource = ''
    this.__data = ''
  }

  async connectedCallback() {
    this.__datasource = localStorage.getItem('datagrid_datasource')

    await fetch(this.__datasource + '/menu', {
      // https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch
      // https://developer.mozilla.org/en-US/docs/Web/API/fetch
      method: 'GET',
    })
      .then((res) => res.json())
      .then((res) => (this.__data = res))

    await fetch(this.getAttribute('template'))
      .then((res) => res.text())
      .then((res) => (this.__template = res))

      console.log('======= LewLogMenu this.__data ========')

      const keys = Object.keys(this.__data)
      const values = Object.values(this.__data)
      console.log(typeof this.__data)
      console.log(this.__data)
      console.log(keys)
      console.log(values)


    this.innerHTML = interpolate(this.__template, this.__data)
  }
}

customElements.define('lew-log-menu', LewLogMenu)
