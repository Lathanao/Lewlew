import { LewElement } from '/js/LewElement.js'
import { interpolate } from '/js/tool/interpolate.js'

export class LewLogStatProgressbar extends LewElement {
  constructor() {
    super()
    this.__data = ''
  }

  async connectedCallback() {
    this.__datasource = localStorage.getItem('datagrid_datasource')

    await fetch(this.__datasource + '/stat', {
      // https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch
      // https://developer.mozilla.org/en-US/docs/Web/API/fetch
      method: 'GET',
    })
      .then((res) => res.json())
      .then((res) => (this.__data = res))

    await fetch(this.getAttribute('template'))
      .then((res) => res.text())
      .then((res) => (this.__template = res))

    const keys = Object.keys(this.__data)
    const values = Object.values(this.__data)

    this.innerHTML = interpolate(this.__template, this.__data)

    let buttonTab = this.querySelectorAll('li')
    let contentTab = this.querySelectorAll('article')
    buttonTab.forEach((el) => {
      el.onclick = (ev) => {

        contentTab.forEach((el) => {
          el.classList.add('opacity-0')
          el.classList.add('hidden')
        })

        let index = [...el.parentElement.children].indexOf(el)
        let newcontent =  contentTab[index]

        newcontent.classList.remove('opacity-0')
        newcontent.classList.remove('hidden')
      }
    })
  }
}

customElements.define('lew-log-stat-progressbar', LewLogStatProgressbar)
