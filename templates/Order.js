import AbstractView from "/templates/AbstractView.js";
import "/wc/datagrid/datagrid.js";


export default class extends AbstractView {
    constructor(params) {
        super(params);
        this.setTitle("Orders");
        this.__template_path = "/templates/Order.html"
    }

    async getHtml() {
        await fetch(this.__template_path)
        .then(res => res.text() )
        .then(res => this.__template = res)
        return this.__template
    }
}