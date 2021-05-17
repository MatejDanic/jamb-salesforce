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

export default class Box extends LightningElement {

    @api box;
    @api columnType;
    @api boxesDisabled;
    @api announcement;

    @track disabled;

    renderedCallback() {
        this.disabled = this.boxesDisabled || this.box.filled || !this.box.available || this.announcement && this.announcement != this.box.type;
    }

    handleClick() {
        if (this.columnType == "boxclick") {
            this.dispatchEvent(new CustomEvent("announce", {
                detail: this.box.type
            }));   
        }
    }
}