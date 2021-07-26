import { LightningElement, wire } from 'lwc';
import getOnlineUsers from '@salesforce/apex/UserController.getOnlineUsers';
import FIELD_USER_ACTIVE from '@salesforce/schema/User.IsActive';

const ERROR_TITLE = "Error";
const ERROR_VARIANT = "Error";


export default class UserList extends LightningElement {

    @wire(getOnlineUsers)
    wiredOnlineUsers;

}