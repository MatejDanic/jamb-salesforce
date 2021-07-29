import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { publish, subscribe, MessageContext } from 'lightning/messageService';
import RECORD_SELECTED_CHANNEL from '@salesforce/messageChannel/RecordSelected__c';

import getGames from '@salesforce/apex/GameController.getGames';
import getUser from '@salesforce/apex/UserController.getUser';

const ERROR_TITLE = "Error";
const ERROR_VARIANT = "Error";

export default class MenuBar extends LightningElement {

    @track user;
 
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
            getUser({
                userId: message.recordId
            }).then((user) => {
                this.user = user;
            }).catch(error => {
                console.error(error);
                this.dispatchEvent(new ShowToastEvent({
                    title: ERROR_TITLE,
                    message: error.body ? error.body.message : error,
                    variant: ERROR_VARIANT,
                }));
            });
        }
    }

    handleGameClick(event) {
        console.log(event.target.id.split("-")[0]);
        const payload = { recordId: event.target.id.split("-")[0], type: "game" };
        publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
    }

}