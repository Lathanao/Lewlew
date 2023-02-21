
export default class {
    constructor(params) {
        this.params = params
        this.__template = ''
        this.__template_path = ''
    }

    setTitle(title) {
        document.title = title
    }

    async getHtml() {
      await fetch(this.__template_path)
      .then(res => res.text() )
      .then(res => this.__template = res)
      return this.__template
  }
}