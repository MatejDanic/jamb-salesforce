import { LightningElement, wire, api, track } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";

//import refreshGame from '@salesforce/apex/GameController.refreshGame';
import rollDiceById from "@salesforce/apex/GameController.rollDiceById";
import toggleFreezeDiceById from "@salesforce/apex/GameController.toggleFreezeDiceById";
import fillById from "@salesforce/apex/GameController.fillById";
import announceById from "@salesforce/apex/GameController.announceById";

import FIELD_FORM from "@salesforce/schema/Game__c.Form__c";
import FIELD_DICE_LIST from "@salesforce/schema/Game__c.Dice_List__c";
import FIELD_ANNOUNCEMENT from "@salesforce/schema/Game__c.Announcement__c";
import FIELD_ROLL_COUNT from "@salesforce/schema/Game__c.Roll_Count__c";

const ERROR_TITLE = "Error";
const ERROR_VARIANT = "Error";
const SUCCESS_TITLE = "Congratulations";
const SUCCESS_MESSAGE = "Your final score is ";
const SUCCESS_VARIANT = "Success";

const FIELD_LIST = [
    FIELD_FORM,
    FIELD_DICE_LIST,
    FIELD_ANNOUNCEMENT,
    FIELD_ROLL_COUNT
];

export default class Game extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: "$recordId", fields: FIELD_LIST })
    game;

    @wire(getRecord, { recordId: "$recordId", fields: FIELD_LIST })
    wiredRecord({ data, error }) {
        if (data) {
            console.log(data);
            const { fields } = data;
            Object.keys(fields).forEach((item) => {
                let value =
                    fields[item] && fields[item].displayValue
                        ? fields[item].displayValue
                        : fields[item].value;
                this.result = { ...this.result, [item]: value };
            });
        }
        if (error) {
            console.error(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: ERROR_TITLE,
                    message: error.body ? error.body.message : error,
                    variant: ERROR_VARIANT
                })
            );
        }
    }

    get form() {
        return JSON.parse(getFieldValue(this.game.data, FIELD_FORM));
    }

    get diceList() {
        return JSON.parse(getFieldValue(this.game.data, FIELD_DICE_LIST));
    }

    get announcement() {
        return getFieldValue(this.game.data, FIELD_ANNOUNCEMENT);
    }

    get rollCount() {
        return getFieldValue(this.game.data, FIELD_ROLL_COUNT);
    }

    get rollDiceButtonDisabled() {
        return (
            this.form.availableBoxes == 0 ||
            this.rollCount == 3 ||
            (this.rollCount == 1 &&
                !this.announcement &&
                this.announcementRequired)
        );
    }

    get diceDisabled() {
        return (
            this.form.availableBoxes == 0 ||
            this.rollCount == 0 ||
            this.rollCount == 3 ||
            this.rollDiceButtonDisabled
        );
    }

    get boxesDisabled() {
        return this.form.availableBoxes == 0 || this.rollCount == 0;
    }

    get announcementRequired() {
        try {
            for (let column of this.form.columnList) {
                if (column.type != "ANNOUNCEMENT") {
                    for (let box of column.boxList) {
                        if (box.isAvailable) {
                            return false;
                        }
                    }
                }
            }
            return true;
        } catch (error) {
            console.error(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: ERROR_TITLE,
                    message: error.body ? error.body.message : error,
                    variant: ERROR_VARIANT
                })
            );
            return false;
        }
    }

    @track firstMove;
    @track rollDiceAnimation;

    connectedCallback() {
        console.log("Game Id: " + this.recordId);
        this.firstMove = true;
        this.rollDiceAnimation = false;
    }

    handleReset() {
        console.log("reset");
        // refreshGame({
        //     gameId: this.recordId
        // }).then(() => {
        //     refreshApex(this.game);
        // }).catch(error => {
        //     console.error(error);
        //     this.dispatchEvent(new ShowToastEvent({
        //         title: ERROR_TITLE,
        //         message: error.body ? error.body.message : error,
        //         variant: ERROR_VARIANT,
        //     }));
        // });
    }

    handleRollDice() {
        if (this.firstMove) {
            this.firstMove = false;
        }
        rollDiceById({
            gameId: this.recordId
        })
            .then(() => {
                refreshApex(this.game);
                this.startRollDiceAnimation();
            })
            .catch((error) => {
                console.error(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: ERROR_TITLE,
                        message: error.body ? error.body.message : error,
                        variant: ERROR_VARIANT
                    })
                );
            });
    }

    startRollDiceAnimation() {
        // let diceRackElement = this.template.querySelector('c-dice-rack');
        // diceRackElement.startRollDiceAnimation();
    }

    handleDiceClick(event) {
        toggleFreezeDiceById({
            gameId: this.recordId,
            order: event.detail
        })
            .then(() => {
                refreshApex(this.game);
            })
            .catch((error) => {
                console.error(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: ERROR_TITLE,
                        message: error.body ? error.body.message : error,
                        variant: ERROR_VARIANT
                    })
                );
            });
    }

    handleBoxClick(event) {
        if (
            event.detail.columnType == "ANNOUNCEMENT" &&
            this.announcement == null
        ) {
            announceById({
                gameId: this.recordId,
                boxTypeString: event.detail.boxType
            })
                .then(() => {
                    refreshApex(this.game);
                })
                .catch((error) => {
                    console.error(error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: ERROR_TITLE,
                            message: error.body ? error.body.message : error,
                            variant: ERROR_VARIANT
                        })
                    );
                });
        } else {
            fillById({
                gameId: this.recordId,
                columnTypeString: event.detail.columnType.toString(),
                boxTypeString: event.detail.boxType.toString()
            })
                .then(() => {
                    refreshApex(this.game).then(() => {
                        if (this.form.availableBoxes == 0) {
                            setTimeout(() => {
                                let message =
                                    SUCCESS_MESSAGE + this.form.finalSum + "!";
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: SUCCESS_TITLE,
                                        message: message,
                                        variant: SUCCESS_VARIANT
                                    })
                                );
                            }, 1000);
                        }
                    });
                })
                .catch((error) => {
                    console.error(error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: ERROR_TITLE,
                            message: error.body ? error.body.message : error,
                            variant: ERROR_VARIANT
                        })
                    );
                });
        }
    }
}
