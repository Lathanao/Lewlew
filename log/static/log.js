import AbstractView from '/js/AbstractView.js'
import { interpolate } from '/js/tool/interpolate.js'

import '/component/datagrid/datagrid.js'
import '/log/dashboard-progressbar.js'
import '/log/log-menu.js'

export default class extends AbstractView {
  constructor(params) {
    super(params)
    this.setTitle('Order')
    this.__template_path = '/log/log.html'
  }
}
