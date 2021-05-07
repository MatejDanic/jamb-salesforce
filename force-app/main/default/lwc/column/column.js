import { LightningElement, api, track } from 'lwc';

export default class Column extends LightningElement {
    @api getColumn;

    @track type;
    @track boxes;

    connectedCallback() {
        // console.log(JSON.parse(JSON.stringify(this.getColumn)));
        this.type = this.getColumn.type;
        this.boxes = this.getColumn.boxes;
        console.log(JSON.parse(JSON.stringify(this.boxes)));
    }
}