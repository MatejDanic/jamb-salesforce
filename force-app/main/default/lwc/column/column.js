import { LightningElement, api, track } from 'lwc';

export default class Column extends LightningElement {

    @api column
    @api boxesDisabled;

    @track isDown;
    @track isUp;
    @track isAny;
    @track isAnn;

    connectedCallback() {
        this.isDown = this.column.type == "Downwards";
        this.isUp = this.column.type == "Upwards";
        this.isAny = this.column.type == "AnyDirection";
        this.isAnn = this.column.type == "Announcement";
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