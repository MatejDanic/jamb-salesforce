import { LightningElement, api } from "lwc";

export default class DiceList extends LightningElement {
    @api startRollDiceAnimation() {
        let diceElements = this.template.querySelectorAll("c-dice");
        for (let diceElement of diceElements) {
            diceElement.startRollDiceAnimation();
        }
    }

    @api diceList;
    @api diceDisabled;
    @api rollDiceAnimation;

    handleDiceClick(event) {
        this.dispatchEvent(
            new CustomEvent("diceclick", {
                detail: event.detail
            })
        );
    }
}
