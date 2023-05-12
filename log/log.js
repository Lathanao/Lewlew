import AbstractView from '/js/AbstractView.js'
import '/component/datagrid/datagrid.js'
import '/log/dashboard-progressbar.js'

export default class extends AbstractView {
  constructor(params) {
    super(params)
    this.setTitle('Order')
    this.__template_path = '/log/log.html'
  }
}
