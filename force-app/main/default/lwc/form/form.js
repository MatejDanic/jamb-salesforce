import { LightningElement, api, track } from 'lwc';
import ImageResource from '@salesforce/resourceUrl/ImageResource';
import rollDice from '@salesforce/apex/GameController.rollDice';


export default class Form extends LightningElement {
    @api getForm;
    @api getRollCount;

    @track form;
    @track rollDiceButtonImage;
    @track rollCount;
    @track diceImages;
    @track numberSum;
    @track diffSum;
    @track labelSum;

    connectedCallback() {
        this.form = this.getForm;
        this.rollCount = this.getRollCount;
        this.rollDiceButtonImage = ImageResource + "/misc/roll_" + this.rollCount + ".png";
        this.diceImages = [];
        for (let i = 1; i <= 6; i++) {
            this.diceImages.push(ImageResource + "/dice/" + i + ".png");
        }
    }

    handleRollDice() {
        rollDice({
            gameId: "a0009000008HOgLAAW",
            diceList: [1, 2, 3, 4, 5]
        }).then(diceList => {
            console.log(diceList);
        }).catch(error => {
            console.log("Error (getGameById):", error);
        });
    }
}