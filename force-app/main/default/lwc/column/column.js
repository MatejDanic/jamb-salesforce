/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 5.6.2021.
 * ____________________________________________________________
 * 
 */

import { LightningElement, api, track } from 'lwc';

export default class Column extends LightningElement {

    @api column
    @api announcement;
    @api rollCount;
    @api announcementRequired;
    @api boxesDisabled;

    @track isDown;
    @track isUp;
    @track isFree;
    @track isAnn;
    @track announcementColumnClass;

    connectedCallback() {
        this.isDown = this.column.type == "DOWNWARDS";
        this.isUp = this.column.type == "UPWARDS";
        this.isFree = this.column.type == "FREE";
        this.isAnn = this.column.type == "ANNOUNCEMENT";
        this.announcementColumnClass = "form-item column-announcement-" + (this.announcementRequired ? "glow" : "normal");
    }

    renderedCallback() {
        this.announcementColumnClass = "form-item column-announcement-" + (this.announcementRequired ? "glow" : "normal");
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