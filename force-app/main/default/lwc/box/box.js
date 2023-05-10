import { LightningElement, api } from "lwc";

export default class Box extends LightningElement {
	
	@api value;
	@api type;
	@api filled;
	@api available;
	@api columnType;
	@api rollCount;
	@api announcement;

	get disabled() {
		// box is disabled before the first dice roll, if it is already filled or if it is just not available
		return this.rollCount == 0 
			|| this.filled 
			|| !this.available
			// if nothing was announced, all boxes in the announcement column are disabled if the player rolled more than once
			|| this.announcement == null 
				&& this.columnType == "ANNOUNCEMENT" 
				&& this.rollCount > 1
			// if an announcement has been made, the box is disabled if it is not in the announcement column or if it is not the announced type
			|| this.announcement != null 
				&& (this.columnType != "ANNOUNCEMENT" 
					|| this.type != this.announcement);
	}

	handleClick() {
		this.dispatchEvent(
			new CustomEvent("boxclick", { detail: { boxType: this.type } })
		);
	}
}