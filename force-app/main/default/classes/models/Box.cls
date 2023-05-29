public class Box implements Comparable {

    public BoxType type { get; private set; }    

    @AuraEnabled
    public transient String typeString {
        get {
            return String.valueOf(type);
        } 
        private set;
    }

    @AuraEnabled
    public Integer value { get; private set; }  

    @AuraEnabled
    public Boolean filled { get; private set; }  

    @AuraEnabled
    public Boolean available { get; set; }
    
    public Box(BoxType type, Boolean available) {
        this.type = type;
        this.available = available;
        this.value = 0;
        this.filled = false;
    }

    public void fill(Integer value) {
        this.value = value;
        this.filled = true;
        this.available = false;
    }

    public Integer compareTo(Object compareTo) {
        Box compareToBox = (Box) compareTo;
        return type.ordinal() - compareToBox.type.ordinal(); 
    }
    
}