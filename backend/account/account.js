import AbstractView from "/templates/AbstractView.js";
// import "/backend/datagrid/datagrid-account.js";
import "/wc/datagrid/datagrid.js";

export default class extends AbstractView {
    constructor(params) {
        super(params);
        this.setTitle("Account");
        this.__template_path = "/backend/datagrid/datagrid-table-account.html"
    }
}


