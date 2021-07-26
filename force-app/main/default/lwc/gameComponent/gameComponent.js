import { LightningElement, track, wire } from 'lwc';

import getGames from '@salesforce/apex/GameController.getGames';

export default class GameComponent extends LightningElement {
 
    @track gameId;

    @wire(getGames)
    wiredGames;

    handleClick(event) {
        console.log(event.target.id);
        this.gameId = event.target.id.split("-")[0];
    }

}