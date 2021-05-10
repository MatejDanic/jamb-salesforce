import { LightningElement, api, track } from 'lwc';
import ImageResource from '@salesforce/resourceUrl/ImageResource';

export default class Dice extends LightningElement {
    @api getDice;
    @api getRollCount;

    @track value;
    @track isHeld;
    @track diceImage;
    @track borderClass;
    @track isDisabled;
    @track rollCount;

    connectedCallback() {
        this.isHeld = false;
        this.value = this.getDice.value;
        this.diceImage = ImageResource + "/dice/" + this.value + ".png";
        this.rollCount = this.getRollCount;
        this.isDisabled = this.rollCount == 0 || this.rollCount == 3;
        this.borderClass = "dice dice-border-" + (this.isDisabled ? "gray" : "black");
    }

    handleClick() {
        this.isHeld = !this.isHeld;
        this.borderClass = "dice dice-border-" + (this.isHeld ? "red" : "gray");
    }
}