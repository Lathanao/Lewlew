import { LewElement } from '/js/LewElement.js'
import { interpolate } from '/js/tool/interpolate.js'

export class LewLogMenu extends LewElement {
  constructor() {
    super()
    this.__datasource = ''
    this.__datamenu = ''
  }

  async connectedCallback() {
    this.__datasource = localStorage.getItem('datagrid_datasource')

    await fetch(this.__datasource + '/menu', { 
      // https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch
      // https://developer.mozilla.org/en-US/docs/Web/API/fetch
      method: 'GET'
    })
      .then((res) => res.json())
      .then((res) => (this.__datamenu = res))

    if (this.hasAttribute('template')) {
      await fetch(this.getAttribute('template'))
        .then((res) => res.text())
        .then((res) => (this.__template = res))
    }

    // this.innerHTML = this.__template
    this.innerHTML = interpolate(this.__template, this.__datamenu)

    // let buttonTab = this.querySelectorAll('li')
    // let contentTab = this.querySelectorAll('article')
    // buttonTab.forEach((el) => {
    //   el.onclick = (ev) => {

    //     contentTab.forEach((el) => {
    //       el.classList.add('opacity-0')
    //       el.classList.add('hidden')
    //     })

    //     let index = [...el.parentElement.children].indexOf(el)
    //     let newcontent =  contentTab[index]

    //     newcontent.classList.remove('opacity-0')
    //     newcontent.classList.remove('hidden')
    //   }
    // })
  }
}

customElements.define('lew-log-menu', LewLogMenu)
