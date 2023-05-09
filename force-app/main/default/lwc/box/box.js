import { LightningElement, api } from "lwc";

export default class Box extends LightningElement {
  @api value;
  @api type;
  @api filled;
  @api available;
  @api columnType;
  @api rollCount;
  @api announcement;
  @api announcementRequired;

  get disabled() {
    // box is disabled before the first dice roll, if it is filled or if it is just not available
    if (this.rollCount == 0 || this.filled || !this.available) return true;
    // if an announcement has been made
    if (this.announcement != null) {
      // box is disabled if it is not in the announcement column or if it is not the announced type
      return (
        this.columnType != "ANNOUNCEMENT" || this.type != this.announcement
      );
    }
    // if none of the above conditions are met, box is not disabled
    return false;
  }

  handleClick() {
    this.dispatchEvent(
      new CustomEvent("boxclick", {
        detail: {
          boxType: this.type,
        },
      })
    );
  }
}