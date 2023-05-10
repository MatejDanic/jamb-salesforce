import { LightningElement, wire, api, track } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";

import restartGameById from "@salesforce/apex/GameController.restartGameById";
import rollDiceByGameId from "@salesforce/apex/GameController.rollDiceByGameId";
import fillBoxByGameId from "@salesforce/apex/GameController.fillBoxByGameId";
import makeAnnouncementByGameId from "@salesforce/apex/GameController.makeAnnouncementByGameId";

import FIELD_GAME_STRING from "@salesforce/schema/Game__c.Game_String__c";

const ERROR_TITLE = "Error";
const ERROR_VARIANT = "Error";
const SUCCESS_TITLE = "Congratulations";
const SUCCESS_MESSAGE = "Your final score is ";
const SUCCESS_VARIANT = "Success";

const FIELD_LIST = [FIELD_GAME_STRING];

export default class Game extends LightningElement {

	@api recordId;

	@track form;
	@track diceList;
	@track rollCount;
	@track announcement;
	@track announcementRequired;

	@track isLoading = false;

	@wire(getRecord, { recordId: "$recordId", fields: FIELD_LIST })
	gameRecord;

	@wire(getRecord, { recordId: "$recordId", fields: FIELD_LIST })
	wiredRecord({ data, error }) {
		if (data) {
			this.isLoading = true;
			let game = JSON.parse(getFieldValue(data, FIELD_GAME_STRING));
			this.form = game.form;
			this.diceList = game.diceList;
			this.rollCount = game.rollCount;
			this.announcement = game.announcement;
			this.announcementRequired = game.announcementRequired;
			this.resetAllDice();
			this.isLoading = false;
		}
		if (error) {
			console.error(error);
			this.showErrorToastMessage(error)
		}
	}

	get debugModeEnabled() {
		return true;
	}

	get rollDiceButtonDisabled() {
		return this.form.numOfAvailableBoxes == 0
			|| this.rollCount == 3
			|| this.rollCount == 1
				&& this.announcement == null
			 	&& this.announcementRequired;
	}

	get allDiceDisabled() {
		return this.form.numOfAvailableBoxes == 0 
			|| this.rollCount == 0
			|| this.rollCount == 3 
			|| this.rollDiceButtonDisabled;
	}

	get allBoxesDisabled() {
		return this.form.numOfAvailableBoxes == 0 || this.rollCount == 0;
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
			.then((diceList) => {
				//this.diceList = diceList;
				//this.rollCount += 1;
				refreshApex(this.gameRecord).then(() => {
					this.startDiceRollAnimation();
				});
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
		if (event.detail.columnType == "ANNOUNCEMENT" && this.announcement == null) {
			this.handleAnnouncement(event.detail.boxType);
		} else {
			this.handleBoxFill(event.detail.columnType, event.detail.boxType);
		}
	}

	handleBoxFill(columnType, boxType) {
		fillBoxByGameId({ gameId: this.recordId, columnTypeString: columnType, boxTypeString: boxType })
			.then((box) => {
				//this.resetAllDice();
				refreshApex(this.gameRecord).then(() => {
					if (this.form.availableBoxes == 0) {
						setTimeout(() => {
							this.showSuccessToastMessage(SUCCESS_MESSAGE + this.form.finalSum + "!");
						}, 1000);
					}
				});
			})
			.catch((error) => {
				console.error(error);
				this.showErrorToastMessage(error)
			});
	}

	handleAnnouncement(boxType) {
		makeAnnouncementByGameId({ gameId: this.recordId, boxTypeString: boxType})
			.then(() => {
				refreshApex(this.gameRecord);
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

	handleRestart() {
		this.isLoading = true;
		restartGameById({ gameId: this.recordId })
			.then((game) => {
				// this.form = game.form;
				// this.diceList = game.diceList;
				// this.announcement = game.announcement;
				// this.announcementRequired = game.announcementRequired;
				// this.rollCount = game.rollCount;
				// this.resetAllDice();
				refreshApex(this.gameRecord);
			})
			.catch((error) => {
				console.error(error);
				this.showErrorToastMessage(error)
			})
			.finally(() => {
				this.isLoading = false;
			});
	}

	showSuccessToastMessage(message) {
		const evt = new ShowToastEvent({
			title: 'Success',
			message: message,
			variant: 'success'
		});
		this.dispatchEvent(evt);
	}
   
   	showErrorToastMessage(error) {
		const evt = new ShowToastEvent({
			title: 'Error',
			message: error?.body?.message,
			variant: 'error'
		});
	   	this.dispatchEvent(evt);
   	}
}