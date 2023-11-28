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
        getGameByRecordId({ gameId: this.recordId })
        .then(game => {
            console.log(game);
            this.game = data;
        })
        .catch((error) => {
            this.showErrorToastMessage(error)
        });
    }

    // handler functions
	handleRollDice(diceToRoll) {
		console.log("Dice to roll: " + diceToRoll);
		rollDiceById({ gameId: this.gameId, actionRequest: { diceToRoll: diceToRoll } })
			.then(game => {
                console.log(game);
				this.game = game;
				this.startDiceRollAnimation();
			})
            .catch((error) => {
				this.showErrorToastMessage(error)
			});
	}

	handleBoxFill(columnTypeString, boxTypeString) {
		fillBoxById({ gameId: this.gameId, actionRequest: { columnTypeString: columnTypeString, boxTypeString: boxTypeString } })
			.then(game => {
                console.log(game);
				this.game = game;
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

	handleMakeAnnouncement(announcementString) {
		makeAnnouncementById({ gameId: this.gameId, actionRequest: { announcementString: announcementString } })
			.then(game => {
                console.log(game);
				this.game = game;
			})
			.catch((error) => {
				this.showErrorToastMessage(error)
			});
	}

    handleRestart() {
		restartById({ gameId: this.gameId })
			.then(game => {
                console.log(game);
				this.game = game;
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
	   	this.dispatchEvent(new ShowToastEvent({
			title: ERROR_TITLE,
			message: error.body ? error.body.message : error,
			variant: ERROR_VARIANT
		}));
   	}

}