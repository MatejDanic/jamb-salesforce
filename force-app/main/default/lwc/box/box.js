import { LightningElement, api } from "lwc";

export default class Box extends LightningElement {
	
	@api value;
	@api typeString;
	@api filled;
	@api available;
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

	get disabled() {
		// box is disabled before the first dice roll, if it is already filled or if it is just not available
		return this.rollCount == 0 
			|| this.filled 
			|| !this.available
			// if nothing was announced, all boxes in the announcementString column are disabled if the player rolled more than once
			|| this.announcementString == null 
				&& this.columnTypeString == "ANNOUNCEMENT" 
				&& this.rollCount > 1
			// if an announcementString has been made, the box is disabled if it is not in the announcementString column or if it is not the announced type
			|| this.announcementString != null 
				&& (this.columnTypeString != "ANNOUNCEMENT" 
					|| this.typeString != this.announcementString);
	}

	handleClick() {
		this.dispatchEvent(
			new CustomEvent("boxclick", { detail: { boxTypeString: this.typeString } })
		);
	}
}