import { LightningElement, wire } from 'lwc';

import { publish, MessageContext } from 'lightning/messageService';
import RECORDS_SELECTED_CHANNEL from '@salesforce/messageChannel/RecordsSelected__c';

import getInventoryItemList from '@salesforce/apex/AvailabilityController.getInventoryItemList';

export default class InventoryItemList extends LightningElement {

    value = [];

    @wire(getInventoryItemList)
    wiredInventoryItemList;

    @wire(MessageContext)
    messageContext


    @wire(getInventoryItemList)
    inventoryItemList;

    get options() {
        let optionsList = [];
        for (let item of this.wiredInventoryItemList.data) {
            optionsList.push({ label: item.Name, value: item.Id })
        }
        return optionsList;
    }

    handleChange(e) {
        this.value = e.detail.value;
        const payload = { recordIdSet: this.value };
        publish(this.messageContext, RECORDS_SELECTED_CHANNEL, payload);
    }
}