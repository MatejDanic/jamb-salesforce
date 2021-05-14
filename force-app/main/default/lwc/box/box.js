import { LightningElement, api, track } from 'lwc';

export default class Box extends LightningElement {
    @api getBox;
    @api getColumnType;

    @track box;
    @track value;
    @track available;
    @track filled;

    @track isMax;
    @track isTrips;

    connectedCallback() {
        this.box = this.getBox;
        this.isMax = this.box.type == "Max";
        this.isTrips = this.box.type == "Trips";
    }
}