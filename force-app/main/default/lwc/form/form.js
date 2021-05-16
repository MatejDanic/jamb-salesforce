import { LightningElement, api, track } from 'lwc';
import ImageResource from '@salesforce/resourceUrl/ImageResource';

export default class Form extends LightningElement {

    @api form;
    @api rollCount;
    @api announcement;
    @api rollDiceButtonDisabled;

    @track rollDiceButtonImage;
    @track rollDiceButtonDisabled;
    @track boxesDisabled;

    @track diceImages;
    @track formClass;
    @track lastColumnClass;
    @track bottomRowClass;
    @track multipleColumns;

    connectedCallback() {
        this.multipleColumns = this.form.columns.length > 1;
        this.rollDiceButtonImage = ImageResource + "/misc/roll_" + this.rollCount + ".png";
        this.diceImages = [];
        for (let i = 1; i <= 6; i++) {
            this.diceImages.push(ImageResource + "/dice/" + i + ".png");
        }
        this.formClass = "form form-columns-" + this.form.columns.length;
        this.lastColumnClass = "label-column last-column-" + this.form.columns.length;
        this.bottomRowClass = "bottom-row bottom-row-end-" + this.form.columns.length;
    }

    renderedCallback() {
        this.rollDiceButtonImage = ImageResource + "/misc/roll_" + this.rollCount + ".png";
        this.rollDiceButtonDisabled = this.rollCount == 3 || this.rollDiceButtonDisabled;
    }

    handleRollDice() {
        this.dispatchEvent(new CustomEvent("rolldice"));
    }

    handleBoxClick(event) {
        this.dispatchEvent(new CustomEvent("boxclick", {
            detail: event.detail
        }));
    }
}