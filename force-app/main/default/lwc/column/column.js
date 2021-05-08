import { LightningElement, api, track } from 'lwc';

export default class Column extends LightningElement {
    @api getColumn;

    @track type;
    @track boxes;
    @track isDown;
    @track isUp;
    @track isAny;
    @track isAnn;

    connectedCallback() {
        // console.log(JSON.parse(JSON.stringify(this.getColumn)));
        this.type = this.getColumn.type;
        this.boxes = this.getColumn.boxes;
        this.isDown = this.type == "Downwards";
        this.isUp = this.type == "Upwards";
        this.isAny = this.type == "AnyDirection";
        this.isAnn = this.type == "Announcement";
        // console.log(JSON.parse(JSON.stringify(this.boxes)));
    }
}