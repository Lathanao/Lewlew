import AbstractView from "/js/AbstractView.js"
import "/component/datagrid/datagrid.js"
export default class extends AbstractView {
  constructor(params) {
    super(params)
    this.setTitle("Account")
    this.__template_path = "/account/datagrid/datagrid-table-account.html"
  }
}
