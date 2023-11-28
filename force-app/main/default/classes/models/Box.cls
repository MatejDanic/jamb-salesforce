public class Box {

    public BoxType type { get; private set; }    

    public String typeString {
        get {
            return String.valueOf(type);
        }
        private set;
    }

    @AuraEnabled
    public Integer value { get; private set; }  
    
    private Box(BoxType type, Integer value) {
        this.type = type;
        this.value = value;
    }  

    public static Box getInstance(BoxType type) {
        return new Box(type, null);
    }

    public void fill(Integer value) {
        this.value = value;
    }
    
}