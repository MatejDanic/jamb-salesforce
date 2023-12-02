import { LightningElement, wire, api, track } from "lwc";

export default class Sheet extends LightningElement {

	@api columns;
	@api rollCount;
	@api announcementString;
	@api rollDiceButtonDisabled;
	@api allDiceDisabled;
	@api allBoxesDisabled;
	@api topSectionSum;
	@api middleSectionSum;
	@api bottomSectionSum;
	@api totalSum;

	// determines if top/middle/bottom lightning bolt in the roll dice button will be filled or not
	get rollCountTopClass() {
		return this.rollCount == 0 ? "filled" : "empty";
	}
	get rollCountMiddleClass() {
		return this.rollCount <= 1 ? "filled" : "empty";
	}
	get rollCountBottomClass() {
		return this.rollCount <= 2 ? "filled" : "empty";
	}

	handleBoxClick(event) {
		let columnTypeString = event.detail.columnTypeString;
		let boxTypeString = event.detail.boxTypeString;
		this.dispatchEvent(new CustomEvent("boxclick", { detail: {
			boxTypeString: boxTypeString,
			columnTypeString: columnTypeString
		}}));
	}

	handleRollDice() {
		this.dispatchEvent(new CustomEvent("rolldice"));
	}

	handleRestart() {		
		this.dispatchEvent(new CustomEvent("restart"));
	}

}