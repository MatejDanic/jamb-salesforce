import { LightningElement, api } from "lwc";

export default class Column extends LightningElement {
  
	@api typeString;
	@api boxes;
	@api topSectionSum;
	@api middleSectionSum;
	@api bottomSectionSum;
	@api rollCount;
	@api announcementString;
	@api announcementRequired;
	@api allBoxesDisabled;

	connectedCallback() {
		for (let box of boxes) {
			let disabled = false;
			if (this.rollCount === 0) {
				disabled = true;
			} else if (this.value != null) {
				disabled = true;
			} else if (this.announcementString != null) {
					disabled = this.columnTypeString !== "ANNOUNCEMENT" || this.typeString !== this.announcementString;
			} else if (this.typeString === "FREE") {
				disabled = false
			} else if (this.typeString === "DOWNWARDS") {
				disabled = this.typeString != "ONES" &&  this.props.boxes[this.props.boxes.findIndex(x => x.typeString === box.typeString) - 1].value == null;
			} else if (this.typeString === "UPWARDS") {
				disabled = this.typeString != "YAMB" &&  this.props.boxes[this.props.boxes.findIndex(x => x.typeString === box.typeString) + 1].value == null;
			} else if (this.typeString === "ANNOUNCEMENT") {
				disabled = this.typeString != "YAMB" &&  this.props.boxes[this.props.boxes.findIndex(x => x.typeString === box.typeString) + 1].value == null;
			}
			box.disabled = disabled;
		}
	}

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