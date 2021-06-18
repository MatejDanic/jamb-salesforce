/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 18.6.2021.
 * ____________________________________________________________
 * 
 */

import { LightningElement, wire, api, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import refreshGame from '@salesforce/apex/GameController.refreshGame';
import rollDice from '@salesforce/apex/GameController.rollDice';
import holdDice from '@salesforce/apex/GameController.holdDice';
import fill from '@salesforce/apex/GameController.fill';
import announce from '@salesforce/apex/GameController.announce';

import GAME_FORM_FIELD from '@salesforce/schema/Game__c.Form__c';
import GAME_DICE_FIELD from '@salesforce/schema/Game__c.Dice__c';
import GAME_ANNOUNCEMENT_FIELD from '@salesforce/schema/Game__c.Announcement__c';
import GAME_ROLL_COUNT_FIELD from '@salesforce/schema/Game__c.Roll_Count__c';

const ERROR_TITLE = "Error";
const ERROR_VARIANT = "Error";
const SUCCESS_TITLE = "Congratulations";
const SUCCESS_MESSAGE = "Your final score is ";
const SUCCESS_VARIANT = "Success";

const GAME_FIELDS = [GAME_FORM_FIELD, GAME_DICE_FIELD, GAME_ANNOUNCEMENT_FIELD, GAME_ROLL_COUNT_FIELD];

export default class Game extends LightningElement {

    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: GAME_FIELDS })
    game;

    get form() {
        return JSON.parse(getFieldValue(this.game.data, GAME_FORM_FIELD));
    }
    get dice() {
        return JSON.parse(getFieldValue(this.game.data, GAME_DICE_FIELD));
    }
    get announcement() {
        return getFieldValue(this.game.data, GAME_ANNOUNCEMENT_FIELD);
    }
    get rollCount() {
        return getFieldValue(this.game.data, GAME_ROLL_COUNT_FIELD);
    }
    get rollDiceButtonDisabled() {
        return this.form.availableBoxes == 0 || this.rollCount == 3 || this.rollCount == 1 && !this.announcement && this.announcementRequired;//isAnouncementRequired(this.form);
    }
    get diceDisabled() {
        return this.form.availableBoxes == 0 || this.rollCount == 0 || this.rollCount == 3 || this.rollDiceButtonDisabled;
    }
    get boxesDisabled() {
        return this.form.availableBoxes == 0 || this.rollCount == 0;
    }
    get announcementRequired() {
        try {
            for (let column of this.form.columns) {
                if (column.type != "ANNOUNCEMENT") {
                    for (let box of column.boxes) {
                        if (box.available) {
                            return false;
                        }
                    }
                }
            }
            return true;
        } catch (error) {
            console.error(error);
            this.dispatchEvent(new ShowToastEvent({
                title: ERROR_TITLE,
                message: error.body ? error.body.message : error,
                variant: ERROR_VARIANT,
            }));
            return false;
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: GAME_FIELDS })
    wiredRecord({ data, error }) {
        if (data) {
            const { fields } = data
            Object.keys(fields).forEach(item => {
                let value = fields[item] && fields[item].displayValue ? fields[item].displayValue : fields[item].value
                this.result = { ...this.result, [item]: value }
            });
        }
        if (error) {
            console.error(error);
            this.dispatchEvent(new ShowToastEvent({
                title: ERROR_TITLE,
                message: error.body ? error.body.message : error,
                variant: ERROR_VARIANT,
            }));
        }
    }

    @track firstMove;

    @track rollDiceAnimation;


    connectedCallback() {
        this.firstMove = true;
        this.rollDiceAnimation = false;
    }

    handleRefresh() {
        refreshGame({
            gameId: this.recordId
        }).then(() => {
            refreshApex(this.game);
        }).catch(error => {
            console.error(error);
            this.dispatchEvent(new ShowToastEvent({
                title: ERROR_TITLE,
                message: error.body ? error.body.message : error,
                variant: ERROR_VARIANT,
            }));
        });
    }

    handleRollDice() {
        if (this.firstMove) {
            this.firstMove = false;
        }
        rollDice({
            gameId: this.recordId
        }).then(() => {
            refreshApex(this.game);
            this.startRollDiceAnimation();
        }).catch(error => {
            console.error(error);
            this.dispatchEvent(new ShowToastEvent({
                title: ERROR_TITLE,
                message: error.body ? error.body.message : error,
                variant: ERROR_VARIANT,
            }));
        });
    }

    startRollDiceAnimation() {
        let diceRackElement = this.template.querySelector('c-dice-rack');
        diceRackElement.startRollDiceAnimation();
    }

    handleHoldDice(event) {
        holdDice({
            gameId: this.recordId,
            order: event.detail
        }).then(() => {
            refreshApex(this.game);
        }).catch(error => {
            console.error(error);
            this.dispatchEvent(new ShowToastEvent({
                title: ERROR_TITLE,
                message: error.body ? error.body.message : error,
                variant: ERROR_VARIANT,
            }));
        });
    }

    handleBoxClick(event) {
        if (event.detail.columnType == "ANNOUNCEMENT" && this.announcement == null) {
            announce({
                gameId: this.recordId,
                boxTypeString: event.detail.boxType
            }).then(() => {
                refreshApex(this.game);
            }).catch(error => {
                console.error(error);
                this.dispatchEvent(new ShowToastEvent({
                    title: ERROR_TITLE,
                    message: error.body ? error.body.message : error,
                    variant: ERROR_VARIANT,
                }));
            });
        } else {
            fill({
                gameId: this.recordId,
                columnTypeString: event.detail.columnType.toString(),
                boxTypeString: event.detail.boxType.toString()
            }).then(() => {
                refreshApex(this.game).then(() => {
                    if (this.form.availableBoxes == 0) {
                        setTimeout(() => {
                            let message = SUCCESS_MESSAGE + this.form.finalSum + "!";
                            this.dispatchEvent(new ShowToastEvent({
                                title: SUCCESS_TITLE,
                                message: message,
                                variant: SUCCESS_VARIANT,
                            }))
                        }, 1000);
                    }
                });
            }).catch(error => {
                console.error(error);
                this.dispatchEvent(new ShowToastEvent({
                    title: ERROR_TITLE,
                    message: error.body ? error.body.message : error,
                    variant: ERROR_VARIANT,
                }));
            });
        }
    }
}