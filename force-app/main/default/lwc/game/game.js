import { LightningElement, wire, api, track } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";

import resetGameById from "@salesforce/apex/GameController.resetGameById";
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
      console.log(game);
      this.form = game.form;
      this.diceList = game.diceList;
      this.rollCount = game.rollCount;
      this.announcement = game.announcement;
      this.announcementRequired = game.announcementRequired;
      this.isLoading = false;
    }
    if (error) {
      console.error(error);
      this.dispatchEvent(
        new ShowToastEvent({
          title: ERROR_TITLE,
          message: error.body ? error.body.message : error,
          variant: ERROR_VARIANT,
        })
      );
    }
  }

  get debugModeEnabled() {
    return true;
  }

  get rollDiceButtonDisabled() {
    return (
      this.form.numOfAvailableBoxes == 0 ||
      this.rollCount == 3 ||
      (this.rollCount == 1 &&
        this.announcement == null &&
        this.announcementRequired)
    );
  }

  get allDiceDisabled() {
    return (
      this.form.numOfAvailableBoxes == 0 ||
      this.rollCount == 0 ||
      this.rollCount == 3 ||
      this.rollDiceButtonDisabled
    );
  }

  get allBoxesDisabled() {
    return this.form.numOfAvailableBoxes == 0 || this.rollCount == 0;
  }

  connectedCallback() {
    console.log("Game Id: " + this.recordId);
  }

  handleReset() {
    this.isLoading = true;
    resetGameById({ gameId: this.recordId })
      .then((game) => {
        this.form = game.form;
        this.diceList = game.diceList;
        this.announcement = game.announcement;
        this.announcementRequired = game.announcementRequired;
        this.rollCount = game.rollCount;
        refreshApex(this.gameRecord);
      })
      .catch((error) => {
        console.error(error);
        this.dispatchEvent(
          new ShowToastEvent({
            title: ERROR_TITLE,
            message: error.body ? error.body.message : error,
            variant: ERROR_VARIANT,
          })
        );
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  handleRollDice() {
    let diceToRoll = [];
    const diceComponents = this.template.querySelectorAll("c-dice");

    for (let dice of diceComponents) {
      if (!dice.frozen) {
        diceToRoll.push(dice.order);
      }
    }

    rollDiceByGameId({ gameId: this.recordId, diceToRoll: diceToRoll })
      .then((diceList) => {
        console.log(diceList);
        this.diceList = diceList;
        refreshApex(this.gameRecord);
        this.startRollDiceAnimation();
      })
      .catch((error) => {
        console.error(error);
        this.dispatchEvent(
          new ShowToastEvent({
            title: ERROR_TITLE,
            message: error.body ? error.body.message : error,
            variant: ERROR_VARIANT,
          })
        );
      });
  }

  startRollDiceAnimation() {
    // let dice = this.template.querySelector('c-dice');
    // diceRackElement.startRollDiceAnimation();
  }

  handleDiceClick(event) {
    toggleFreezeDiceById({ gameId: this.recordId, order: event.detail.order })
      .then((dice) => {
        this.diceList[dice.order] = dice;
      })
      .catch((error) => {
        console.error(error);
        this.dispatchEvent(
          new ShowToastEvent({
            title: ERROR_TITLE,
            message: error.body ? error.body.message : error,
            variant: ERROR_VARIANT,
          })
        );
      });
  }

  handleBoxClick(event) {
    if (event.detail.columnType == "ANNOUNCEMENT") {
      makeAnnouncementByGameId({
        gameId: this.recordId,
        boxTypeString: event.detail.boxType,
      })
        .then(() => {
          refreshApex(this.gameRecord);
        })
        .catch((error) => {
          console.error(error);
          this.dispatchEvent(
            new ShowToastEvent({
              title: ERROR_TITLE,
              message: error.body ? error.body.message : error,
              variant: ERROR_VARIANT,
            })
          );
        });
    } else {
      fillBoxByGameId({
        gameId: this.recordId,
        columnTypeString: event.detail.columnType,
        boxTypeString: event.detail.boxType,
      })
        .then((box) => {
          console.log(box);
          refreshApex(this.gameRecord).then(() => {
            if (this.form.availableBoxes == 0) {
              setTimeout(() => {
                let message = SUCCESS_MESSAGE + this.form.finalSum + "!";
                this.dispatchEvent(
                  new ShowToastEvent({
                    title: SUCCESS_TITLE,
                    message: message,
                    variant: SUCCESS_VARIANT,
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
              variant: ERROR_VARIANT,
            })
          );
        });
    }
  }
}
