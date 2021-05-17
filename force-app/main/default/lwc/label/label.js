/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 17.5.2021.
 * ____________________________________________________________
 * 
*/

import { LightningElement, api, track } from 'lwc';

export default class Label extends LightningElement {
    @api getText;

    @track text;

    connectedCallback() {
        this.text = this.getText;
    }
}