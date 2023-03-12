import AbstractView from "/js/AbstractView.js";
// import "/backend/datagrid/datagrid-account.js";
import "/component/datagrid/datagrid.js";

export default class extends AbstractView {
    constructor(params) {
        super(params);
        this.setTitle("Account");
        this.__template_path = "/backend/datagrid/datagrid-table-account.html"
    }
}


