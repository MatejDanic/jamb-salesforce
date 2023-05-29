import { LightningElement, wire, api, track } from "lwc";

import getSheetFromGameId from "@salesforce/apex/GameController.getSheetFromGameId";
import rollDiceByGameId from "@salesforce/apex/GameController.rollDiceByGameId";
import fillBoxByGameId from "@salesforce/apex/GameController.fillBoxByGameId";
import makeAnnouncementByGameId from "@salesforce/apex/GameController.makeAnnouncementByGameId";

export default class Sheet extends LightningElement {

	@api gameId;
	// variable used only for chaining wired functions, ignored in the actual implementation
	@api lastModifiedDate;
    @api debugModeEnabled;

	// the reason that the sheet variable is "manually" wired is because of performance reasons
	// on each imperative apex method call, a sheet is returned and inputted in this variable
	// this way, there is no need to wait for the wired method chain to update the displayed game state data
	@track sheet;

	// second wire function in the chain (the first is in game.js) used for actually retrieving data to display
	@wire(getSheetFromGameId, { gameId: "$gameId", lastModifiedDate: "$lastModifiedDate" })
	wiredSheet({data, error}) {
		if (data) {
			this.sheet = data;
		}
		if (error) {
			this.handleError(error);
		}
	}

	// game sheet properties
    get columnList() {
        return this.sheet?.columnList;
    }
	get diceList() {
		return this.sheet?.diceList;
	}
	get rollCount() {
		return this.sheet?.rollCount;
	}
	get announcementString() {
		return this.sheet?.announcementString;
	}
	get announcementRequired() {
		return this.sheet?.announcementRequired;
	}
	get completed() {
		return this.sheet?.completed;
	}
	get actionHistory() {
		return this.sheet?.actionHistory;
	}
    get topSectionSum() {
        return this.sheet?.topSectionSum;
    }
    get middleSectionSum() {
        return this.sheet?.middleSectionSum;
    }
    get bottomSectionSum() {
        return this.sheet?.bottomSectionSum;
    }
    get totalSum() {
        return this.sheet?.totalSum;
    }

	// computed properties
	get rollDiceButtonDisabled() {
		return this.completed
			|| this.rollCount == 3
			|| this.rollCount == 1
				&& this.announcementString == null
			 	&& this.announcementRequired;
	}

	get allDiceDisabled() {
		return this.completed 
			|| this.rollCount == 0
			|| this.rollCount == 3 
			|| this.rollDiceButtonDisabled;
	}

	get allBoxesDisabled() {
		return this.completed == 0 || this.rollCount == 0;
	}

	// reverse order of action history elements to show latest first
    get actionHistoryReversed() {
		let actionHistoryReversed = [...this.actionHistory];
		return actionHistoryReversed.reverse();
	}

	// action history but with all elements except n-first removed
	get actionHistoryTruncated() {
		let actionHistoryTruncated = this.actionHistoryReversed;
		// cut everything after the nth element
		/*if (actionHistoryTruncated.length >= 5) {
			actionHistoryTruncated.length = 5;
		}*/
		return actionHistoryTruncated;
	}

	// determines if top/middle/bottom lightning bolt in the roll dice button will be filled or not
	get rollCountTopClass() {
		return this.rollCount == 0 ? "roll-count-filled" : "";
	}
	get rollCountMiddleClass() {
		return this.rollCount <= 1 ? "roll-count-filled" : "";
	}
	get rollCountBottomClass() {
		return this.rollCount <= 2 ? "roll-count-filled" : "";
	}

	// handler functions
	handleRollDice() {
		// find which dice are not "frozen" and add their order value to an array 
		// this is used as an input parameter for the rollDice apex method
		let diceToRoll = [];
		for (let dice of this.template.querySelectorAll("c-dice")) {
			if (!dice.frozen) {
				diceToRoll.push(dice.order);
			}
		}
		console.log("Dice to roll: " + diceToRoll);
		rollDiceByGameId({ gameId: this.gameId, diceToRoll: diceToRoll })
			.then((sheet) => {
				console.log(sheet);
				// immediately update the sheet upon method return
				this.sheet = sheet;
				this.startDiceRollAnimation();
			})
			.catch((error) => {
				this.handleError(error)
			})
			.finally(() => {
				this.handleRefresh();
			});
	}

	// determine if click action is filling the box or announcing it based on current game state and the clicked box 
	handleBoxClick(event) {
		if (event.detail.columnTypeString == "ANNOUNCEMENT" && this.announcementString == null) {
			this.handleAnnouncement(event.detail.boxTypeString);
		} else {
			this.handleBoxFill(event.detail.columnTypeString, event.detail.boxTypeString);
		}
	}

	handleBoxFill(columnTypeString, boxTypeString) {
		fillBoxByGameId({ gameId: this.gameId, columnTypeString: columnTypeString, boxTypeString: boxTypeString })
			.then((sheet) => {
				console.log(sheet);
				this.sheet = sheet;
				this.resetAllDice();
				// if (this.completed) {
				// 	setTimeout(() => {
				// 		this.showSuccessToastMessage(MESSAGE_FINAL_SCORE + this.form.finalSum + "!");
				// 	}, 1000);
				// }
			})
			.catch((error) => {
				this.handleError(error)
			})
			.finally(() => {
				this.handleRefresh();
			});
	}

	handleAnnouncement(announcementString) {
		makeAnnouncementByGameId({ gameId: this.gameId, announcementString: announcementString})
			.then((sheet) => {
				console.log(sheet);
				this.sheet = sheet;
			})
			.catch((error) => {
				this.handleError(error)
			})
			.finally(() => {
				this.handleRefresh();
			});
	}
	
    handleError(error) {
        console.error(error);
        this.dispatchEvent(new CustomEvent("error", { 
			detail: error 
		}));    
    }

	handleRefresh() {
		this.dispatchEvent(new CustomEvent("refresh"));
	}

	// helper functions	
	resetAllDice() {
		for (let dice of this.template.querySelectorAll("c-dice")) {
			dice.frozen = false;
		}
	}

	startDiceRollAnimation() {
		// fetch all dice elements and start their roll animation asynchronously if they are not frozen to mimick rolling
		for (let dice of this.template.querySelectorAll("c-dice")) {
			if (!dice.frozen) {
				setTimeout(function () {
					dice.startRollAnimation()
				}, 0);
			}
		}
	}
}