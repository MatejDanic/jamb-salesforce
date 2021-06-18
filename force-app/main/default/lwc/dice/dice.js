/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 18.6.2021.
 * ____________________________________________________________
 * 
*/

import { LightningElement, api, track } from 'lwc';
import ImageResource from '@salesforce/resourceUrl/ImageResource';

export default class Dice extends LightningElement {

    @api startRollDiceAnimation() {
        if (!this.dice.held) {
            let time = Math.round(800 + Math.random() * 1000);
            let diceElement = this.template.querySelector('[data-id="dice' + this.dice.order + '"]')
            setTimeout(function () {
                diceElement.style.animationDuration = time + "ms";
                diceElement.style.animationIterationCount = Math.round(1 + Math.random() * 3);
                diceElement.classList.add("roll");
                Math.random() > 0.5 ? diceElement.classList.add("clockwise") : diceElement.classList.add("counterclockwise");
            }, 0);
            setTimeout(function () {
                diceElement.classList.remove('roll');
                diceElement.classList.remove('clockwise');
                diceElement.classList.remove('counterclockwise');
            }, time);
        }
    }

    @api dice;
    @api diceDisabled;
    @api rollDiceAnimation

    @track diceImage;
    @track diceClass;
    @track diceId

    renderedCallback() {
        this.diceId = "dice" + this.dice.order;
        this.diceImage = ImageResource + "/dice/" + this.dice.value + ".png";
        this.diceClass = "dice dice-border-" + (this.diceDisabled ? "gray" : (this.dice.held ? "red" : "black"));
    }

    handleHoldDice() {
        this.dispatchEvent(new CustomEvent("holddice", {
            detail: this.dice.order
        }));
    }

}