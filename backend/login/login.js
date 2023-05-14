import AbstractView from '/js/AbstractView.js'
export default class extends AbstractView {
  constructor(params) {
    super(params)
    this.setTitle('Login')
    this.__template_path = '/backend/login.html'
  }
}
