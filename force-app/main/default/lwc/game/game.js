import { LightningElement, api, track } from 'lwc';
import getGameById from '@salesforce/apex/GameController.getGameById';


export default class Game extends LightningElement {
    @api recordId;

    @track game;
    @track gameId;

    connectedCallback() {
        console.log("Initialization...")
        this.gameId = this.recordId;
        this.callGetGameById = this.callGetGameById.bind(this);
        this.callGetGameById(this.gameId);
    }

    callGetGameById(gameId) {
        // console.log("Game ID:", gameId);
        getGameById({
            gameId: gameId
        }).then(game => {
            this.game = JSON.parse(game);
            console.log("Game:", JSON.parse(JSON.stringify(this.game)));
        }).catch(error => {
            console.log("Error (getGameById):", error);
        });
    }
}