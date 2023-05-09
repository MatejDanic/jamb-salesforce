import { LightningElement, api, track } from "lwc";

export default class Column extends LightningElement {
  @api type;
  @api boxList;
  @api sum1;
  @api sum2;
  @api sum3;
  @api rollCount;
  @api announcement;
  @api announcementRequired;
  @api allBoxesDisabled;

  get isDown() {
    return this.type == "DOWNWARDS";
  }
  get isUp() {
    return this.type == "UPWARDS";
  }
  get isFree() {
    return this.type == "FREE";
  }
  get isAnn() {
    return this.type == "ANNOUNCEMENT";
  }

  handleBoxClick(event) {
    this.dispatchEvent(
      new CustomEvent("boxclick", {
        detail: {
          boxType: event.detail.boxType,
          columnType: this.type,
        },
      })
    );
  }
}