import { LightningElement, api, track } from 'lwc';

export default class DiceRack extends LightningElement {
    @api getDiceList;

    @track diceList;

    connectedCallback() {
        this.diceList = this.getDiceList;
    }
}