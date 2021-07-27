import { LightningElement, wire } from 'lwc';
import getActiveUsers from '@salesforce/apex/UserController.getActiveUsers';

export default class UserList extends LightningElement {

    @wire(getActiveUsers)
    wiredActiveUsers;

    handleUserClick(event) {
        const payload = { recordId: event.target.id.split("-")[0], type: "user" };
        publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
    }

}