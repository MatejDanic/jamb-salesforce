import { LightningElement, api } from 'lwc';
export default class GameRecordPageComponent extends LightningElement {

    @api recordId;

    connectedCallback() {
        console.log(this.recordId);
    }

}