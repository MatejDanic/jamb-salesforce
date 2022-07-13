public with sharing class Dice {
    public Integer value { get; private set; }
    public Integer order { get; private set; }
    private Boolean isFrozen { get; set; }

    public Dice(Integer order) {
        this.order = order;
        this.value = 6;
        this.isFrozen = false;
    }

    public void roll() {
        if (!isFrozen) {
            value = 1 + Integer.valueOf(Math.random() * 6);
        }
    }

    public void toggleFreeze() {
        isFrozen = !isFrozen;
    }

    public void reset() {
        isFrozen = false;
    }
}
