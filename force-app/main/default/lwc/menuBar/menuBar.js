import { LightningElement, track, wire } from 'lwc';

import getGames from '@salesforce/apex/GameController.getGames';
import { publish, subscribe, MessageContext } from 'lightning/messageService';

import RECORD_SELECTED_CHANNEL from '@salesforce/messageChannel/RecordSelected__c';

export default class MenuBar extends LightningElement {

    @track userId;
 
    @wire(getGames)
    wiredGames;

    @wire(MessageContext)
    messageContext

    subscription;

    connectedCallback() {
        this.subscribeToMessageChannel();
    }
    
    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            RECORD_SELECTED_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    handleMessage(message) {
        if (message.type == "user") {
            this.userId = message.recordId;
        }
    }

    handleGameClick(event) {
        console.log(event.target.id.split("-")[0]);
        const payload = { recordId: event.target.id.split("-")[0], type: "game" };
        publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
    }

}