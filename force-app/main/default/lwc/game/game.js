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

	// determines if verbose game state information is displayed on the screen
	@track debugModeEnabled = false;

	// there are a total of 2 wired methods in the chain of this lwc hierarchy (game.js->sheet.js) 
	// the first method retreives the game record data and serves as a listener for record updates outside of the component
	// the second wire method is located in the sheet component and it is used to retreive the actual data for displaying from the apex controller
	// the reason that the Sheet__c field value of the Game__c record is not used and a custom wired method is called instead,
	// is that the properties of the Sheet apex class that the lwc requires for displaying data are not 
	// identical to the properties being serialized and saved to the database 
	// most game state properties are computed at runtime (similar to formula fields) and not saved
	// this helps prevent invalid save state issues, i.e. future changes in game logic won't break current game instances
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