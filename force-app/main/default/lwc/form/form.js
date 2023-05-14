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
	@api actionHistory;

	handleRollDice() {
		this.dispatchEvent(new CustomEvent("rolldice"));
	}

	handleBoxClick(event) {
		this.dispatchEvent(new CustomEvent("boxclick", { 
			detail: event.detail 
		}));
	}

	handleRestart() {
		if (confirm("Are you sure you want to restart?")) {
			this.dispatchEvent(new CustomEvent("restart"));
		}
	}

	get actionHistoryTruncated() {
		// copy array to perform reverse and cut operations
		let actionHistoryTruncated = [...this.actionHistory];
		console.log("before reverse " + actionHistoryTruncated);
		// reverse order to show latest actions at the top
		actionHistoryTruncated.reverse();
		console.log("after reverse " + actionHistoryTruncated);
		if (actionHistoryTruncated.length > 5) {
			// cut everything after the 5th element
			actionHistoryTruncated.length = 5;
			console.log("after cut " + actionHistoryTruncated);
		} 
		return actionHistoryTruncated;
	}

	get rollCountTopClass() {
		return this.rollCount == 0 ? "roll-count-filled" : "";
	}

	get rollCountMiddleClass() {
		return this.rollCount <= 1 ? "roll-count-filled" : "";
	}

	get rollCountBottomClass() {
		return this.rollCount <= 2 ? "roll-count-filled" : "";
	}

}