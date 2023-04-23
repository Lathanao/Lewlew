import AbstractView from '/templates/AbstractView.js'
import '/component/form/form.js'

export default class extends AbstractView {
  constructor(params) {
    super(params)
    this.setTitle('AdminAccount')
    this.__template_path = '/templates/AdminAccount.html'
  }
}
