import { LightningElement, wire } from 'lwc';

import { publish, MessageContext } from 'lightning/messageService';
import RECORD_SELECTED_CHANNEL from '@salesforce/messageChannel/RecordSelected__c';

import getActiveUsers from '@salesforce/apex/UserController.getActiveUsers';

export default class UserList extends LightningElement {

    @wire(getActiveUsers)
    wiredActiveUsers;
    
    @wire(MessageContext)
    messageContext

    handleUserClick(event) {
        const payload = { recordId: event.target.id.split("-")[0], type: "user" };
        publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
    }

}