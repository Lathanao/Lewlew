import AbstractView from '/js/AbstractView.js'
import '/component/datagrid/datagrid.js'

export default class extends AbstractView {
  constructor(params) {
    super(params)
    this.setTitle('Orders')
    this.__template_path = '/order/order.html'
  }
}
