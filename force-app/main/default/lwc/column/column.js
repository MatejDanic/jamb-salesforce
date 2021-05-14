import { LightningElement, api, track } from 'lwc';

export default class Column extends LightningElement {
    @api getColumn;

    @track column
    @track isDown;
    @track isUp;
    @track isAny;
    @track isAnn;

    connectedCallback() {
        // console.log(JSON.parse(JSON.stringify(this.getColumn)));
        this.column = this.getColumn;
        this.isDown = this.column.type == "Downwards";
        this.isUp = this.column.type == "Upwards";
        this.isAny = this.column.type == "AnyDirection";
        this.isAnn = this.column.type == "Announcement";
        // console.log(JSON.parse(JSON.stringify(this.boxes)));
    }
}