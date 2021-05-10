import { LightningElement, api, track } from 'lwc';
import ImageResource from '@salesforce/resourceUrl/ImageResource';

export default class Form extends LightningElement {
    @api getForm;
    @api getRollCount;

    @track form;
    @track columns;
    @track rollDiceButtonImage;
    @track rollCount;
    @track diceImages;
    @track numberSum;
    @track diffSum;
    @track labelSum;

    connectedCallback() {
        this.form = this.getForm;
        this.columns = this.form.columns;
        this.rollCount = this.getRollCount;
        this.rollDiceButtonImage = ImageResource + "/misc/roll_" + this.rollCount + ".png";
        this.diceImages = [];
        for (let i=1; i<=6; i++) {
            this.diceImages.push(ImageResource + "/dice/" + i + ".png");
        }
    }
}