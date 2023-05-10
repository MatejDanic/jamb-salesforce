import { LightningElement, api, track } from "lwc";

export default class Dice extends LightningElement {
	
    @api value;
    @api order;
	@api rollCount;
    @api allDiceDisabled;

    _frozen = false;

	@api 
	get frozen() {
		return this._frozen;
	}
	set frozen(value) {
		this.setFrozen(value);
	}
	
	setFrozen(frozen) {
		this._frozen = frozen;
		let dice = this.template.querySelector(".dice")
		if (this._frozen) {
			dice.classList.add("red-border");
		} else {
			dice.classList.remove("red-border");
		}
	}

	@api startRollAnimation() {
		let dice = this.template.querySelector(".dice");
		dice.classList.add("roll");
		let time = Math.round(800 + Math.random() * 1000);
		dice.style.animationDuration = time + "ms";
		dice.style.animationIterationCount = Math.round(1 + Math.random() * 3);
		Math.random() > 0.5 ? dice.classList.add("clockwise") : dice.classList.add("counter-clockwise");
		setTimeout(function () {
			dice.classList.remove("roll");
			dice.classList.remove("clockwise");
			dice.classList.remove("counter-clockwise");
		}, time);
	}

    handleClick() {
      	this.setFrozen(!this._frozen);
    }

	get isOne() {
		return this.value == 1;
	}
	get isTwo() {
		return this.value == 2;
	}
	get isThree() {
		return this.value == 3;
	}
	get isFour() {
		return this.value == 4;
	}
	get isFive() {
		return this.value == 5;
	}
	get isSix() {
		return this.value == 6;
	}
	
}