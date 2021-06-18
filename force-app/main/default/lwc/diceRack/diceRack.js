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

import { LightningElement, api } from 'lwc';

export default class DiceRack extends LightningElement {

    @api startRollDiceAnimation() {
        let diceElements = this.template.querySelectorAll("c-dice");
        for (let diceElement of diceElements) {
            diceElement.startRollDiceAnimation();
        }
    }

    @api diceList;
    @api diceDisabled;
    @api rollDiceAnimation

    handleHoldDice(event) {
        this.dispatchEvent(new CustomEvent("holddice", {
            detail: event.detail
        }));
    }

}