public class Dice {

    @AuraEnabled
    public Integer index { get; private set; }  
    
    @AuraEnabled
    public Integer value { get; private set; }   

    private Dice(Integer index, Integer value) {
        this.index = index;
        this.value = value;
    }

    public static Dice getInstance(Integer index) {
        return new Dice(index, 6);
    }

    public void roll() {
        value = 1 + Integer.valueOf(Math.random() * 6);
    }

}