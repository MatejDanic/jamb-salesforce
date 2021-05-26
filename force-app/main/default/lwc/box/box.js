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

export default class Box extends LightningElement {

    @api box;
    @api columnType;
    @api boxesDisabled;
    @api announcement;
    @api rollCount;

    @track disabled;
    
    // connectedCallback() {
    //     this.disabled = this.boxesDisabled || this.box.filled || !this.box.available || 
    //                     this.columnType == "ANNOUNCEMENT" && (this.announcement && this.announcement != this.box.type || !this.announcement && this.rollCount != 1) || 
    //                     this.columnType != "ANNOUNCEMENT" && this.announcement;
    //     this.boxClass = "box box-" + ((this.columnType == "ANNOUNCEMENT" && this.announcement == this.box.type) ? "announcement" : "normal");
    // }

    renderedCallback() {
        this.disabled = this.boxesDisabled || this.box.filled || !this.box.available || 
                        this.columnType == "ANNOUNCEMENT" && (this.announcement && this.announcement != this.box.type || !this.announcement && this.rollCount != 1) || 
                        this.columnType != "ANNOUNCEMENT" && this.announcement;
        this.boxClass = "box box-" + ((this.columnType == "ANNOUNCEMENT" && this.announcement == this.box.type) ? "announcement" : "normal");
    }

    handleClick() {
        this.dispatchEvent(new CustomEvent("boxclick", {
            detail: this.box.type
        }));
    }
}