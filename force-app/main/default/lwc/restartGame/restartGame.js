import { LightningElement, api } from 'lwc';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import restartGameByGameId from "@salesforce/apex/GameController.restartGameByGameId";

export default class RestartGame extends LightningElement {

    @api recordId;

    @api invoke() {
        restartGameByGameId({ gameId: this.recordId })
            .then((game) => {
                console.log(game);
                notifyRecordUpdateAvailable([{recordId: this.recordId}]);
            })
            .catch((error) => {
                console.error(error);
            });
    }

}