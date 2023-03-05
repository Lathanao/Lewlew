import AbstractView from "/templates/AbstractView.js";
export default class extends AbstractView {
    constructor(params) {
        super(params);
        this.setTitle("Forget Password");
        this.__template_path = "/backend/forget.html"
    }
}