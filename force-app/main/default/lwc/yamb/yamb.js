import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getGameByRecordId from "@salesforce/apex/GameController.getGameByRecordId";
import rollDiceById from "@salesforce/apex/GameController.rollDiceById";
import fillBoxById from "@salesforce/apex/GameController.fillBoxById";
import makeAnnouncementById from "@salesforce/apex/GameController.makeAnnouncementById";
import restartById from "@salesforce/apex/GameController.restartById";


const ERROR_TITLE = "Error";
const ERROR_VARIANT = "error";
const SUCCESS_TITLE = "Success";
const SUCCESS_VARIANT = "success";

export default class Yamb extends LightningElement {

	@api recordId;

    @track game;

    connectedCallback() {
        console.log("recordId: " + this.recordId);
        getGameByRecordId({ 
			gameId: this.recordId 
		})
        .then(data => {
            console.log(data);
            this.game = data;
        })
        .catch((error) => {
            this.showErrorToastMessage(error)
        });
    }

	handleRollDice(event) {
		let diceToRoll = event.detail;
		console.log(diceToRoll);
		rollDiceById({
			gameId: this.recordId, 
			actionRequest: { diceToRoll: diceToRoll }
		})
		.then(data => {
			console.log(data);
			this.game = data;
			this.startDiceRollAnimation();
		})
		.catch((error) => {
			this.showErrorToastMessage(error)
		});
	}

	startDiceRollAnimation() {
		console.log("Roll");
	}

	handleBoxFill(event) {
		let columnTypeString = event.detail.columnTypeString;
		let boxTypeString = event.detail.boxTypeString;
		console.log(columnTypeString + " " + boxTypeString);
		fillBoxById({ 
			gameId: this.recordId, 
			actionRequest: { columnTypeString: columnTypeString, boxTypeString: boxTypeString } 
		})
		.then(data => {
			console.log(data);
			this.game = data;
			this.resetAllDice();
			// if (this.sheet.completed) {
			// 	setTimeout(() => {
			// 		this.showSuccessToastMessage(MESSAGE_FINAL_SCORE + this.form.finalSum + "!");
			// 	}, 1000);
			// }
		})
		.catch((error) => {
			this.showErrorToastMessage(error)
		});
	}

	handleMakeAnnouncement(event) {
		let boxTypeString = event.detail.boxTypeString;
		makeAnnouncementById({ 
			gameId: this.recordId, 
			actionRequest: { boxTypeString: boxTypeString } 
		})
		.then(data => {
			console.log(data);
			this.game = data;
		})
		.catch((error) => {
			this.showErrorToastMessage(error)
		});
	}

    handleRestart() {
		restartById({ 
			gameId: this.recordId
		})
		.then(data => {
			console.log(data);
			this.game = data;
		})
		.catch((error) => {
			this.showErrorToastMessage(error)
		});
	}

	showSuccessToastMessage(message) {
		this.dispatchEvent(new ShowToastEvent({
			title: SUCCESS_TITLE,
			message: message,
			variant: SUCCESS_VARIANT
		}));
	}
   
   	showErrorToastMessage(error) {
		console.error(error);
	   	this.dispatchEvent(new ShowToastEvent({
			title: ERROR_TITLE,
			message: error.body ? error.body.message : error,
			variant: ERROR_VARIANT
		}));
   	}

}