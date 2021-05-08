import { LightningElement, api, track } from 'lwc';
import Dice_1 from '@salesforce/resourceUrl/Dice_1';
import Dice_2 from '@salesforce/resourceUrl/Dice_2';
import Dice_3 from '@salesforce/resourceUrl/Dice_3';
import Dice_4 from '@salesforce/resourceUrl/Dice_4';
import Dice_5 from '@salesforce/resourceUrl/Dice_5';
import Dice_6 from '@salesforce/resourceUrl/Dice_6';

export default class Dice extends LightningElement {
    @api getDice;

    @track value;
    @track isHeld;

    connectedCallback() {
        this.isHeld = false;
        this.value = this.getDice.value;
    }

    handleClick() {
        this.isHeld = !this.isHeld;
    }
}