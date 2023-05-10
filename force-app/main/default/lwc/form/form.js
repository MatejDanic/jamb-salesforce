import { LightningElement, api, track } from "lwc";

export default class Form extends LightningElement {
	@api columnList;
	@api sum1;
	@api sum2;
	@api sum3;
	@api totalSum;
	@api rollCount;
	@api announcement;
	@api announcementRequired;
	@api rollDiceButtonDisabled;
	@api allBoxesDisabled;

	handleRollDice() {
		this.dispatchEvent(new CustomEvent("rolldice"));
	}

	handleBoxClick(event) {
		this.dispatchEvent(
		new CustomEvent("boxclick", { 
			detail: event.detail 
		}));
	}

	handleRestart() {
		if (confirm("Are you sure you want to restart?")) {
			this.dispatchEvent(new CustomEvent("restart"));
		}
	}
}