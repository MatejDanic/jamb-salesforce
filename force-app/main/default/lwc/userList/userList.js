import { LightningElement, wire } from 'lwc';
import getActiveUsers from '@salesforce/apex/UserController.getActiveUsers';

export default class UserList extends LightningElement {

    @wire(getActiveUsers)
    wiredActiveUsers;

}