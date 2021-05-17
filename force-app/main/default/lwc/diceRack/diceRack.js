/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 17.5.2021.
 * ____________________________________________________________
 * 
*/

import { LightningElement, api } from 'lwc';

export default class DiceRack extends LightningElement {

    @api diceList;
    @api diceDisabled;

    handleHoldDice(event) {
        this.dispatchEvent(new CustomEvent("holddice", {
            detail: event.detail
        }));
    }

}