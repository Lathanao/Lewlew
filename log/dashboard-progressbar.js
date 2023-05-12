import { LewElement } from '/js/LewElement.js'

export class LewDashboardDemo extends LewElement {
  constructor() {
    super()
    this.build()
  }

  create(state, props, storage, query) {

    return this.__template
  }

  async connectedCallback() {

    if (this.hasAttribute('template')) {
      await fetch(this.getAttribute('template'))
        .then((res) => res.text())
        .then((res) => (this.__template = res))
    }
    this.innerHTML = this.__template

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

customElements.define('lew-dashboard-progressbar', LewDashboardDemo)