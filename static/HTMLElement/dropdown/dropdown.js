export class WCDropDown extends HTMLElement {

  constructor() {
    super();
    this.__initialized = false;
    this.__template = "";
    this.__datasource = {};
  }

  async connectedCallback() {

    if (this.hasAttribute('source')) {
      await fetch(this.getAttribute('source'))
      .then(res => res.json())
      .then(res => this.__datasource = res);
    }

    if (this.hasAttribute('template')) {
      await fetch(this.getAttribute('template'))
      .then(res => res.text() )
      .then(res => this.__template = res)
    }

    this.addEventListener("click", function (e) {

      let menu = this.querySelector('.menu')
    
      if (menu.classList.contains("opacity-0")) {
        menu.classList.remove("ease-in");
        menu.classList.remove("duration-75");
        menu.classList.add("ease-out");
        menu.classList.add("duration-100");

        menu.classList.remove("opacity-0");
        menu.classList.remove("scale-95");
        menu.classList.add("opacity-100");
        menu.classList.add("scale-100");

        setTimeout(function () {
          menu.classList.toggle("hidden");
        }, 100);
      } else {
        menu.classList.remove("ease-in");
        menu.classList.remove("duration-100");
        menu.classList.add("ease-out");
        menu.classList.add("duration-75");

        menu.classList.remove("opacity-100");
        menu.classList.remove("scale-100");
        menu.classList.add("opacity-0");
        menu.classList.add("scale-95");

        setTimeout(function () {
          menu.classList.toggle("hidden");
        }, 75);
      }
    });

    this.render()
  }

  render() {
    this.innerHTML = this.__template;
    this.__initialized = true;
  }
}

customElements.define('wc-dropdown', WCDropDown)