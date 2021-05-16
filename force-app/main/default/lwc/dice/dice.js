import { LightningElement, api, track } from 'lwc';
import ImageResource from '@salesforce/resourceUrl/ImageResource';

export default class Dice extends LightningElement {

    @api dice;
    @api diceDisabled;

    @track diceImage;
    @track borderClass;

    renderedCallback() {
        this.diceImage = ImageResource + "/dice/" + this.dice.value + ".png";
        this.borderClass = "dice dice-border-" + (this.diceDisabled ? "gray" : (this.dice.held ? "red" : "black"));
    }

    handleHoldDice() {
        this.dispatchEvent(new CustomEvent("holddice", {
            detail: this.dice.order
        }));
    }
}