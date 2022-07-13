import { LightningElement, api, track } from "lwc";

export default class Column extends LightningElement {
    @api column;
    @api announcement;
    @api rollCount;
    @api announcementRequired;
    @api boxesDisabled;

    connectedCallback() {
        this.isDown = this.column.type == "DOWNWARDS";
        this.isUp = this.column.type == "UPWARDS";
        this.isFree = this.column.type == "FREE";
        this.isAnn = this.column.type == "ANNOUNCEMENT";
    }

    renderedCallback() {
        this.announcementColumnClass =
            "form-item column-announcement-" +
            (this.announcementRequired ? "glow" : "normal");
    }

    handleBoxClick(event) {
        this.dispatchEvent(
            new CustomEvent("boxclick", {
                detail: {
                    boxType: event.detail,
                    columnType: this.column.type
                }
            })
        );
    }
}
