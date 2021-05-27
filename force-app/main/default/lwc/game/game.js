/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 27.5.2021.
 * ____________________________________________________________
 * 
 */

import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getGame from '@salesforce/apex/GameController.getGame';
import refreshGame from '@salesforce/apex/GameController.refreshGame';
import rollDice from '@salesforce/apex/GameController.rollDice';
import holdDice from '@salesforce/apex/GameController.holdDice';
import fill from '@salesforce/apex/GameController.fill';
import announce from '@salesforce/apex/GameController.announce';

const ERROR_TITLE = "Error";
const ERROR_VARIANT = "Error";

export default class Game extends LightningElement {

    @api recordId;

    @track gameId;
    @track gameLoaded;

    @track game;
    @track diceDisabled;
    @track rollDiceButtonDisabled;
    @track boxesDisabled;

    connectedCallback() {
        this.gameId = this.recordId;
        this.callGetGame(this.gameId);
    }

    callGetGame(gameId) {
        getGame({
            gameId: gameId
        }).then(game => {
            game = JSON.parse(game);
            console.log("Game:", JSON.parse(JSON.stringify(game)));
            this.game = game;
            this.setParameters(this.game);
        }).catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: ERROR,
                message: error,
                variant: ERROR,
            }));
        });
    }

    handleRefresh() {
        refreshGame({
            gameId: this.gameId
        }).then(game => {
            game = JSON.parse(game);
            console.log("Game:", JSON.parse(JSON.stringify(game)));
            this.game = game;
            this.setParameters(this.game);
        }).catch(error => {
            console.log(error);
            this.dispatchEvent(new ShowToastEvent({
                title: ERROR_TITLE,
                message: error.body.message,
                variant: ERROR_VARIANT,
            }));
        });
    }

    setParameters(game) {
        this.rollDiceButtonDisabled = game.rollCount == 3 || game.rollCount == 1 && !game.announcement && this.isAnouncementRequired(game.form);
        console.log("Roll Dice Button Disabled", this.rollDiceButtonDisabled);
        this.diceDisabled = game.rollCount == 0 || game.rollCount == 3 || this.rollDiceButtonDisabled;
        console.log("Dice Disabled", this.diceDisabled);
        this.boxesDisabled = game.rollCount == 0;
        console.log("Boxes Disabled", this.boxesDisabled);
    }

    isAnouncementRequired(form) {
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
    }

    handleRollDice() {
        rollDice({
            gameId: this.gameId
        }).then(diceList => {
            diceList = JSON.parse(diceList);
            console.log("Dice", diceList);
            if (this.game.rollCount < 3) {
                this.game.rollCount = this.game.rollCount + 1;
            }
            this.game.dice = diceList;
            this.setParameters(this.game);
        }).catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: ERROR,
                message: error,
                variant: ERROR,
            }));
        });
    }

    handleHoldDice(event) {
        holdDice({
            gameId: this.gameId,
            order: event.detail
        }).then(diceList => {
            diceList = JSON.parse(diceList);
            console.log("Dice", diceList);
            this.game.dice = diceList;
        }).catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: ERROR,
                message: error,
                variant: ERROR,
            }));
        });
    }

    handleBoxClick(event) {
        if (event.detail.columnType == "ANNOUNCEMENT" && this.game.announcement == null) {
            announce({
                gameId: this.gameId,
                boxTypeString: event.detail.boxType
            }).then(announcement => {
                this.game.announcement = announcement;
                this.setParameters(this.game);
            }).catch(error => {
                console.log("Error (announce):", error);
            });
        } else {
            fill({
                gameId: this.gameId,
                columnTypeString: event.detail.columnType.toString(),
                boxTypeString: event.detail.boxType.toString()
            }).then(game => {
                game = JSON.parse(game);
                this.game = game;
                this.setParameters(this.game);
            }).catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: ERROR,
                    message: error,
                    variant: ERROR,
                }));
            });
        }
    }
}