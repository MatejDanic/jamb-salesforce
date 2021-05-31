/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 31.5.2021.
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

const FIELDS = [GAME_FORM_FIELD, GAME_DICE_FIELD, GAME_ANNOUNCEMENT_FIELD, GAME_ROLL_COUNT_FIELD];

export default class Game extends LightningElement {

    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
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
        return this.rollCount == 3 || this.rollCount == 1 && !this.announcement && this.isAnouncementRequired(this.form);
    }
    get diceDisabled() {
        return this.rollCount == 0 || this.rollCount == 3 || this.rollDiceButtonDisabled;
    }
    get boxesDisabled() {
        return this.rollCount == 0;
    }


    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ data, error }) {
        if (data) {
            const { fields } = data
            Object.keys(fields).forEach(item => {
                let value = fields[item] && fields[item].displayValue ? fields[item].displayValue : fields[item].value
                this.result = { ...this.result, [item]: value }
            })
        }
        if (error) {
            console.error(error);
            this.dispatchEvent(new ShowToastEvent({
                title: ERROR_TITLE,
                message: error.body.message,
                variant: ERROR_VARIANT,
            }));
        }
    }

    handleRefresh() {
        refreshGame({
            gameId: this.recordId
        }).then(game => {
            // game = JSON.parse(game);
            // console.log("Game:", JSON.parse(JSON.stringify(game)));
            // this.game = game;
            refreshApex(this.game);
        }).catch(error => {
            console.log(error);
            this.dispatchEvent(new ShowToastEvent({
                title: ERROR_TITLE,
                message: error.body.message,
                variant: ERROR_VARIANT,
            }));
        });
    }

    handleRollDice() {
        rollDice({
            gameId: this.recordId
        }).then(diceList => {
            // diceList = JSON.parse(diceList);
            // console.log("Dice", diceList);
            // this.game.dice = diceList;
            refreshApex(this.game);
            // this.setParameters(this.game);
        }).catch(error => {
            console.error(error);
            this.dispatchEvent(new ShowToastEvent({
                title: ERROR_TITLE,
                message: error.body.message,
                variant: ERROR_VARIANT,
            }));
        });
    }

    handleHoldDice(event) {
        holdDice({
            gameId: this.recordId,
            order: event.detail
        }).then(diceList => {
            // diceList = JSON.parse(diceList);
            // console.log("Dice", diceList);
            // this.dice = diceList;
            refreshApex(this.game);
        }).catch(error => {
            console.error(error);
            this.dispatchEvent(new ShowToastEvent({
                title: ERROR_TITLE,
                message: error.body.message,
                variant: ERROR_VARIANT,
            }));
        });
    }

    handleBoxClick(event) {
        if (event.detail.columnType == "ANNOUNCEMENT" && this.announcement == null) {
            announce({
                gameId: this.recordId,
                boxTypeString: event.detail.boxType
            }).then(announcement => {
                // this.game.announcement = announcement;
                // this.setParameters(this.game);
                refreshApex(this.game);
            }).catch(error => {
                console.error(error);
                this.dispatchEvent(new ShowToastEvent({
                    title: ERROR_TITLE,
                    message: error.body.message,
                    variant: ERROR_VARIANT,
                }));
            });
        } else {
            fill({
                gameId: this.recordId,
                columnTypeString: event.detail.columnType.toString(),
                boxTypeString: event.detail.boxType.toString()
            }).then(game => {
                // game = JSON.parse(game);
                // this.game = game;
                // this.setParameters(this.game);
                refreshApex(this.game);
            }).catch(error => {
                console.error(error);
                this.dispatchEvent(new ShowToastEvent({
                    title: ERROR_TITLE,
                    message: error.body.message,
                    variant: ERROR_VARIANT,
                }));
            });
        }
    }

    isAnouncementRequired(form) {
        try {
            for (let column of form.columns) {
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
                message: error.body.message,
                variant: ERROR_VARIANT,
            }));
        }
    }
}