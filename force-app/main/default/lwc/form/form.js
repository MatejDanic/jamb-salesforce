import { LightningElement, api, track } from "lwc";

export default class Form extends LightningElement {
    @api form;
    @api announcement;
    @api rollCount;
    @api announcementRequired;
    @api firstMove;
    @api rollDiceButtonDisabled;
    @api boxesDisabled;

    handleRollDice() {
        this.dispatchEvent(new CustomEvent("rolldice"));
    }

    handleBoxClick(event) {
        this.dispatchEvent(
            new CustomEvent("boxclick", {
                detail: event.detail
            })
        );
    }

    handleRefresh() {
        this.dispatchEvent(new CustomEvent("refresh"));
    }
}
