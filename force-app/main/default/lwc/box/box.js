import { LightningElement, api } from "lwc";

export default class Box extends LightningElement {
	
	@api value;
	@api typeString;
	@api filled;
	@api disabled;
	@api columnTypeString;
	@api rollCount;
	@api announcementString;

	get boxClass() {
		if (this.columnTypeString == "ANNOUNCEMENT" && this.announcementString == this.typeString) {
			return "box red-border";
		} else {
			return "box";
		}
	}

	handleClick() {
		this.dispatchEvent(
			new CustomEvent("boxclick", { detail: { boxTypeString: this.typeString } })
		);
	}
}