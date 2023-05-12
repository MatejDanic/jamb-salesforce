public class Box implements Comparable {

    public BoxType type { get; private set; }    

    public Box(BoxType type, Boolean available) {
        this.type = type;
        this.available = available;
        this.value = 0;
        this.filled = false;
    }

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

    public void fill(Integer value) {
        this.value = value;
        this.filled = true;
        this.available = false;
    }

    public BoxType getNextBoxType(ColumnType cType) {
        BoxType nextBoxType;
        if (cType == ColumnType.DOWNWARDS && type != BoxType.YAMB) {
            nextBoxType = BoxType.values()[type.ordinal() + 1];
        } else if (cType == ColumnType.UPWARDS && type != BoxType.ONES) {
            nextBoxType = BoxType.values()[type.ordinal() - 1];
        }
        return nextBoxType;
    }

    public Integer compareTo(Object compareTo) {
        Box compareToBox = (Box) compareTo;

        Integer returnValue = 0;
        if (type.ordinal() > compareToBox.type.ordinal()) {
            returnValue = 1;
        } else if (type.ordinal() < compareToBox.type.ordinal()) {
            returnValue = -1;
        }

        return returnValue;       
    }
    
}