import { LightningElement, api, track } from 'lwc';

export default class Box extends LightningElement {
    @api getBox;
    @api getColumnType;

    @track value;
    @track available;
    @track filled;
    @track type;

    @track isMax;
    @track isTrips;

    connectedCallback() {
        // console.log(JSON.parse(JSON.stringify(this.getBox)));
        // console.log(JSON.parse(JSON.stringify(this.getColumnType)));
        this.type = this.getBox.type;
        this.isMax = this.type == "Max";
        this.isTrips = this.type == "Trips";
    }
}