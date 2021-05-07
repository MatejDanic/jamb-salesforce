import { LightningElement, api, track } from 'lwc';

export default class Label extends LightningElement {
    @api getText;

    @track text;

    connectedCallback() {
        this.text = this.getText;
    }
}