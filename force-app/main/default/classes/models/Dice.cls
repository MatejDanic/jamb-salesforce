public class Dice implements Comparable {

    @AuraEnabled
    public Integer value { get; private set; }
    @AuraEnabled
    public Integer order { get; private set; }    

    public Dice(Integer order) {
        this.order = order;
        this.value = 6;
    }

    public void roll() {
        value = 1 + Integer.valueOf(Math.random() * 6);
    }

    public Integer compareTo(Object compareTo) {
        Dice compareToDice = (Dice) compareTo;
        return order - compareToDice.order;     
    }

}