import { LightningElement, track, wire } from 'lwc';

import { subscribe, MessageContext } from 'lightning/messageService';
import RECORDS_SELECTED_CHANNEL from '@salesforce/messageChannel/RecordsSelected__c';
import getOpportunities from '@salesforce/apex/AvailabilityController.getOpportunities';

export default class ProductAvailability extends LightningElement {

    opportunityList;

    subscription;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            RECORDS_SELECTED_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    handleMessage(message) {
        console.log(message);
        getOpportunities({
            accountIdSet: message.recordIdSet
        }).then((opportunityList) => {
            console.log(opportunityList);
            this.opportunityList = opportunityList;
        }).catch(error => {
            console.error(error);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body ? error.body.message : error,
                variant: 'Error',
            }));
        });
    }

}