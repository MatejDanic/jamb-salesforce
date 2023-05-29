import { LightningElement, api } from "lwc";

export default class Label extends LightningElement {
	
	@api value;
	@api helpText;
	@api icon;

	get disabled() {
		return this.helpText == null;
	}

}