import AbstractView from "/templates/AbstractView.js";
import "/wc/form/form.js";

export default class extends AbstractView {
    constructor(params) {
        super(params);
        this.setTitle("AdminAccount");
        this.__template_path = "/templates/AdminAccount.html"
    }
}