import { LightningElement, api } from "lwc";

export default class Form extends LightningElement {

	@api columnList;
	@api topSectionSum;
	@api middleSectionSum;
	@api bottomSectionSum;
	@api totalSum;
	@api rollCount;
	@api announcementString;
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

	// handleRestart() {
	// 	if (confirm("Are you sure you want to restart?")) {
	// 		this.dispatchEvent(new CustomEvent("restart"));
	// 	}
	// }
}