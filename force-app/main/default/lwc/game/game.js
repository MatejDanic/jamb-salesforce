import { LightningElement, wire, api, track } from "lwc";
//import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
//import { refreshApex } from "@salesforce/apex";

import getGameFromGameId from "@salesforce/apex/GameController.getGameFromGameId";
import rollDiceByGameId from "@salesforce/apex/GameController.rollDiceByGameId";
import fillBoxByGameId from "@salesforce/apex/GameController.fillBoxByGameId";
import makeAnnouncementByGameId from "@salesforce/apex/GameController.makeAnnouncementByGameId";

const ERROR_TITLE = "Error";
const ERROR_VARIANT = "error";
const SUCCESS_TITLE = "Success";
const SUCCESS_VARIANT = "success";
const MESSAGE_FINAL_SCORE = "Congratulations, Your final score is ";

export default class Game extends LightningElement {

	@api recordId;

	//@track isLoading = false;

	@track	game;

	@wire(getGameFromGameId, { gameId: "$recordId" })
	wiredGame({data, error}) {
		if (data) {
			console.log(data);
			this.game = data;
		}
		if (error) {
			console.error(error);
			this.showErrorToastMessage(error);
		}
	}
	
	get form() {
		return this.game?.form;
	}
	get diceList() {
		return this.game?.diceList;
	}
	get rollCount() {
		return this.game?.rollCount;
	}
	get announcementString() {
		return this.game?.announcementString;
	}
	get announcementRequired() {
		return this.game?.announcementRequired;
	}
	get completed() {
		return this.game?.completed;
	}

	get debugModeEnabled() {
		return true;
	}

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

	connectedCallback() {
		console.log("Game Id: " + this.recordId);
	}

	handleRollDice() {
		let diceToRoll = [];
		for (let dice of this.template.querySelectorAll("c-dice")) {
			if (!dice.frozen) {
				diceToRoll.push(dice.order);
			}
		}
		rollDiceByGameId({ gameId: this.recordId, diceToRoll: diceToRoll })
			.then((game) => {
				console.log(game);
				this.game = game;
				this.startDiceRollAnimation();
				// refreshApex(this.gameRecord).then(() => {
				// 	this.startDiceRollAnimation();
				// });
			})
			.catch((error) => {
				console.error(error);
				this.showErrorToastMessage(error)
			});
	}

	startDiceRollAnimation() {
		for (let dice of this.template.querySelectorAll("c-dice")) {
			if (!dice.frozen) {
				setTimeout(function () {
					dice.startRollAnimation()
				}, 0);
			}
		}
	}

	handleBoxClick(event) {
		if (event.detail.columnTypeString == "ANNOUNCEMENT" && this.announcementString == null) {
			this.handleAnnouncement(event.detail.boxTypeString);
		} else {
			this.handleBoxFill(event.detail.columnTypeString, event.detail.boxTypeString);
		}
	}

	handleBoxFill(columnTypeString, boxTypeString) {
		fillBoxByGameId({ gameId: this.recordId, columnTypeString: columnTypeString, boxTypeString: boxTypeString })
			.then((game) => {
				console.log(game);
				this.game = game;
				this.resetAllDice();
				if (this.form?.availableBoxes == 0) {
					setTimeout(() => {
						this.showSuccessToastMessage(MESSAGE_FINAL_SCORE + this.form.finalSum + "!");
					}, 1000);
				}
			})
			.catch((error) => {
				console.error(error);
				this.showErrorToastMessage(error)
			});
	}

	handleAnnouncement(announcementString) {
		makeAnnouncementByGameId({ gameId: this.recordId, announcementString: announcementString})
			.then((game) => {
				console.log(game);
				this.game = game;
				//refreshApex(this.gameRecord);
			})
			.catch((error) => {
				console.error(error);
				this.showErrorToastMessage(error)
			});
	}
	
	resetAllDice() {
		for (let dice of this.template.querySelectorAll("c-dice")) {
			dice.frozen = false;
		}
	}

	// handleRestart() {
	// 	this.isLoading = true;
	// 	restartGameById({ gameId: this.recordId })
	// 		.then((game) => {
	// 			console.log(game);
	// 			this.resetAllDice();
	// 			refreshApex(this.gameRecord);
	// 		})
	// 		.catch((error) => {
	// 			console.error(error);
	// 			this.showErrorToastMessage(error)
	// 		})
	// 		.finally(() => {
	// 			this.isLoading = false;
	// 		});
	// }

	showSuccessToastMessage(message) {
		this.dispatchEvent(new ShowToastEvent({
			title: SUCCESS_TITLE,
			message: message,
			variant: SUCCESS_VARIANT
		}));
	}
   
   	showErrorToastMessage(error) {
	   	this.dispatchEvent(new ShowToastEvent({
			title: ERROR_TITLE,
			message: error?.body?.message,
			variant: ERROR_VARIANT
		}));
   	}
}