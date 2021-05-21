/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 21.5.2021.
 * ____________________________________________________________
 * 
 */

import { LightningElement, api, track } from 'lwc';
import getGameById from '@salesforce/apex/GameController.getGameById';
import rollDice from '@salesforce/apex/GameController.rollDice';
import holdDice from '@salesforce/apex/GameController.holdDice';
import fill from '@salesforce/apex/GameController.fill';
import announce from '@salesforce/apex/GameController.announce';



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
        this.callGetGameById = this.callGetGameById.bind(this);
        this.isAnouncementRequired = this.isAnouncementRequired.bind(this);
        this.setParameters = this.setParameters.bind(this);
        this.callGetGameById(this.gameId);
    }

    callGetGameById(gameId) {
        getGameById({
            gameId: gameId
        }).then(game => {
            game = JSON.parse(game);
            console.log("Game:", JSON.parse(JSON.stringify(game)));
            this.game = game;
            this.setParameters(this.game);
        }).catch(error => {
            console.log("Error (getGameById):", error);
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
            console.log(JSON.parse(JSON.stringify(column)));
            if (column.type != "ANNOUNCEMENT") {
                for (let box of column.boxes) { 
                    console.log(JSON.parse(JSON.stringify(box)));
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
            if (this.game.rollCount < 3) {
                this.game.rollCount = this.game.rollCount + 1;
            }
            this.game.dice = diceList;
            this.setParameters(this.game);
        }).catch(error => {
            console.log("Error (rollDice):", error);
        });
    }

    handleHoldDice(event) {
        holdDice({
            gameId: this.gameId,
            order: event.detail
        }).then(diceList => {
            diceList = JSON.parse(diceList);
            this.game.dice = diceList;
        }).catch(error => {
            console.log("Error (holdDice):", error);
        });
    }

    handleBoxClick(event) {
        if (event.detail.columnType == "ANNOUNCEMENT" && this.game.announcement == null) {
            announce({
                gameId: this.gameId,
                boxTypeString: event.detail.boxType
            }).then(announcement => {
                console.log(announcement);
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
                console.log("Error (fill):", error);
            });
        }
    }
}