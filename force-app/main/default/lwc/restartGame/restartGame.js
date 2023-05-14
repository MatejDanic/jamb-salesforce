import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import LightningConfirm from 'lightning/confirm';
import GameMessageChannel from '@salesforce/messageChannel/GameMessageChannel__c';

import restartGameByGameId from "@salesforce/apex/GameController.restartGameByGameId";

export default class RestartGame extends LightningElement {

    @api recordId;

	@wire(MessageContext)
    messageContext;

    @api invoke() {
        this.handleClick();
    }

    async handleClick() {
        const result = await LightningConfirm.open({label: "Are you sure you want to restart?"});
        if (result) {
            restartGameByGameId({ gameId: this.recordId })
                .then((game) => {
                    this.publishGameToMessageChannel(game);
                })
                .catch((error) => {
                    console.error(error);
                });
        }
    }

    publishGameToMessageChannel(game) {
        publish(this.messageContext, GameMessageChannel, {
            game: game
        });
    }

}