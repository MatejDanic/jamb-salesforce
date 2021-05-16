import { LightningElement, api, track } from 'lwc';

export default class DiceRack extends LightningElement {

    @api diceList;
    @api diceDisabled;

    handleHoldDice(event) {
        this.dispatchEvent(new CustomEvent("holddice", {
            detail: event.detail
        }));
    }

}