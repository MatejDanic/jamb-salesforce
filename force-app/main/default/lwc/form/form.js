import { LightningElement, api, track } from 'lwc';

export default class Form extends LightningElement {
    @api getForm;

    @track columns;

    connectedCallback() {
        this.columns = this.getForm.columns;
        console.log(JSON.parse(JSON.stringify(this.getForm)));
    }
}