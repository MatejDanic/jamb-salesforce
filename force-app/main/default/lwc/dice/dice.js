import { LightningElement, api, track } from "lwc";

export default class Dice extends LightningElement {
  @api value;
  @api order;
  @api allDiceDisabled;

  @track frozen = false;

  @api get frozen() {
    return this.frozen;
  }

  get diceClass() {
    let diceClass = "dice";
    if (this.frozen) {
      diceClass += " dice-frozen";
    }
    return diceClass;
  }

  handleClick() {
    this.frozen = !this.frozen;
  }
}