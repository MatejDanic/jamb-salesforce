import { LightningElement, api, track } from 'lwc';

export default class DiceRack extends LightningElement {
    @api getDiceList;
    @api getRollCount;

    @track diceList;
    @track rollCount;

    connectedCallback() {
        this.diceList = this.getDiceList;
        this.rollCount = this.getRollCount;
    }
}