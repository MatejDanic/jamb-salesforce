/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 26.5.2021.
 * ____________________________________________________________
 * 
*/

import { LightningElement, api, track } from 'lwc';
import ImageResource from '@salesforce/resourceUrl/ImageResource';

export default class Dice extends LightningElement {

    @api dice;
    @api diceDisabled;

    @track diceImage;
    @track diceClass;

    renderedCallback() {
        this.diceImage = ImageResource + "/dice/" + this.dice.value + ".png";
        this.diceClass = "dice dice-border-" + (this.diceDisabled ? "gray" : (this.dice.held ? "red" : "black"));
    }

    handleHoldDice() {
        this.dispatchEvent(new CustomEvent("holddice", {
            detail: this.dice.order
        }));
    }
}