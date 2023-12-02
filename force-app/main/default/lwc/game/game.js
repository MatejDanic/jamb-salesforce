import { LightningElement, api, track } from "lwc";

export default class Game extends LightningElement {

	@api rollCount;
	@api announcementString;
	@api sheet;
	@api dices;	
	@api statusString;

	@track diceToRoll = [0, 1, 2, 3, 4];

	get rollDiceButtonDisabled() {
		return this.statusString == "FINISHED"
			|| this.rollCount == 3
			|| this.rollCount == 1
				&& this.announcementString == null
			 	&& this.announcementRequired;
	}

	get allDiceDisabled() {
		return this.statusString == "FINISHED" 
			|| this.rollCount == 0
			|| this.rollCount == 3 
			|| this.rollDiceButtonDisabled;
	}

	get allBoxesDisabled() {
		return this.completed == 0 || this.rollCount == 0;
	}

	// determine if click action is filling the box or announcing it based on current game state and the clicked box 
	handleDiceClick(event) {
		let index = event.detail;
		if (this.diceToRoll.includes(index)) {
			this.diceToRoll.splice(this.diceToRoll.indexOf(index), 1);
		} else {
			this.diceToRoll.push(index);
		}
	}

	// determine if click action is filling the box or announcing it based on current game state and the clicked box 
	handleBoxClick(event) {
		let columnTypeString = event.detail.columnTypeString;
		let boxTypeString = event.detail.boxTypeString;
		if (columnTypeString == "ANNOUNCEMENT" && this.announcementString == null) {
			this.dispatchEvent(new CustomEvent("makeannouncement", { detail: {
				boxTypeString: boxTypeString,
			}}));
		} else {
			this.dispatchEvent(new CustomEvent("fillbox", { detail: {
				boxTypeString: boxTypeString,
				columnTypeString: columnTypeString
			}}));
		}
	}

	handleRollDice() {
		this.dispatchEvent(new CustomEvent("rolldice", { detail: this.diceToRoll }));
	}

	handleRestart() {		
		this.dispatchEvent(new CustomEvent("restart"));
	}

}