import AbstractView from "/templates/AbstractView.js";
import "/wc/datagrid/wc-datagrid.js";


export default class extends AbstractView {
    constructor(params) {
        super(params);
        this.setTitle("Orders");
        this.__template_path = "/templates/Account.html"
    }
}