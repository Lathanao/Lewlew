import AbstractView from "/js/AbstractView.js";
import "/component/wc-blink.js";
import "/component/wc-hello.js";
export default class extends AbstractView {
    constructor(params) {
        super(params);
        this.setTitle("Login");
        this.__template_path = "/backend/login.html"
        console.log('Hello from lew/backend/login/login.js')
    }
}