import { LightningElement, api, track } from 'lwc';

export default class Column extends LightningElement {

    @api column
    @api boxesDisabled;

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
                box: event.detail,
                column: this.column.type
            }
        }));
    }
}