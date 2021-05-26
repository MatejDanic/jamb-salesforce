/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 26.5.2021.
 * ____________________________________________________________
 * 
 */

import { LightningElement, api, track } from 'lwc';

export default class Column extends LightningElement {

    @api column
    @api boxesDisabled;
    @api rollCount;
    @api announcement;

    @track isDown;
    @track isUp;
    @track isAny;
    @track isAnn;

    connectedCallback() {
        this.isDown = this.column.type == "DOWNWARDS";
        this.isUp = this.column.type == "UPWARDS";
        this.isAny = this.column.type == "ANYDIRECTION";
        this.isAnn = this.column.type == "ANNOUNCEMENT";
    }

    handleBoxClick(event) {
        this.dispatchEvent(new CustomEvent("boxclick", {
            detail: {
                boxType: event.detail,
                columnType: this.column.type
            }
        }));
    }
}