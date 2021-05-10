import { LightningElement, api, track } from 'lwc';
import ImageResource from '@salesforce/resourceUrl/ImageResource';

export default class Form extends LightningElement {
    @api getForm;
    @api getRollCount;

    @track columns;
    @track rollDiceButtonImage;
    @track rollCount;

    connectedCallback() {
        this.columns = this.getForm.columns;
        this.rollCount = this.getRollCount;
        this.rollDiceButtonImage = ImageResource + "/misc/roll_" + this.rollCount + ".png";
        // console.log(JSON.parse(JSON.stringify(this.getForm)));
    }
}