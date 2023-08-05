import { LightningElement, wire, api, track } from "lwc";
import { refreshApex } from '@salesforce/apex';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import Id from '@salesforce/user/Id';
import USER_DEBUG_MODE_ENABLED_FIELD from '@salesforce/schema/User.UserPreferencesUserDebugModePref';

import GAME_SHEET_FIELD from '@salesforce/schema/Game__c.Sheet__c';

const ERROR_TITLE = "Error";
const ERROR_VARIANT = "error";
const SUCCESS_TITLE = "Success";
const SUCCESS_VARIANT = "success";

export default class Game extends LightningElement {

	@api recordId;

	// determines if game state information is displayed on the screen
	@track debugModeEnabled = false;

	@wire(getRecord, { recordId: '$recordId', fields: [ GAME_SHEET_FIELD ] })
	record;

	@wire(getRecord, { recordId: Id, fields: [ USER_DEBUG_MODE_ENABLED_FIELD ]}) 
    currentUserInfo({error, data}) {
        if (data) {
            this.debugModeEnabled = data.fields.UserPreferencesUserDebugModePref.value;
        } else if (error) {
            this.error = error ;
        }
    }

	handleRefresh() {
        console.log("handleRefresh");
        refreshApex(this.record);
    }

	handleError(event) {
		this.showErrorToastMessage(event.detail);
	}

	showSuccessToastMessage(message) {
		this.dispatchEvent(new ShowToastEvent({
			title: SUCCESS_TITLE,
			message: message,
			variant: SUCCESS_VARIANT
		}));
	}
   
   	showErrorToastMessage(error) {
	   	this.dispatchEvent(new ShowToastEvent({
			title: ERROR_TITLE,
			message: error.body ? error.body.message : error,
			variant: ERROR_VARIANT
		}));
   	}

}