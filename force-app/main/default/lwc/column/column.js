import { LightningElement, api } from "lwc";

export default class Column extends LightningElement {
  
	@api typeString;
	@api boxList;
	@api topSectionSum;
	@api middleSectionSum;
	@api bottomSectionSum;
	@api rollCount;
	@api announcementString;
	@api announcementRequired;
	@api allBoxesDisabled;

	get isDown() {
		return this.typeString == "DOWNWARDS";
	}
	get isUp() {
		return this.typeString == "UPWARDS";
	}
	get isFree() {
		return this.typeString == "FREE";
	}
	get isAnn() {
		return this.typeString == "ANNOUNCEMENT";
	}

	handleBoxClick(event) {
		this.dispatchEvent(new CustomEvent("boxclick", { detail: {
			boxTypeString: event.detail.boxTypeString,
			columnTypeString: this.typeString
		}}));
	}
}