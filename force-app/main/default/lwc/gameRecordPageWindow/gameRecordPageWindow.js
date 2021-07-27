import { LightningElement, api } from 'lwc';

export default class GameRecordPageWindow extends LightningElement {

    @api recordId;

    connectedCallback() {
        console.log(this.recordId);
    }

}