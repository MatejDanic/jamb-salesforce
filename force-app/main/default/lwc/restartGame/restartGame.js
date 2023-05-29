import { LightningElement, api } from 'lwc';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';

import LightningConfirm from 'lightning/confirm';

import restartByGameId from "@salesforce/apex/GameController.restartByGameId";

export default class RestartGame extends LightningElement {

    @api recordId;

    @api invoke() {
        this.handleClick();
    }

    async handleClick() {
        const result = await LightningConfirm.open({
            label: "Restart Game", 
            message: "Are you sure you want to restart this Game?"
        });
        if (result) {
            restartByGameId({ gameId: this.recordId })
                .then((sheet) => {
                    console.log(sheet);
                    notifyRecordUpdateAvailable([{recordId: this.recordId}]);
                })
                .catch((error) => {
                    console.error(error);
                });
        }
    }

}