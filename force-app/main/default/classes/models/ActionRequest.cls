public class ActionRequest {

    @AuraEnabled
    public Integer[] diceToRoll { get; private set; }

    @AuraEnabled
    public String columnTypeString { get; private set; }

    @AuraEnabled
    public String boxTypeString { get; private set; }

    public BoxType bType {
        get {
            return BoxType.valueOf(boxTypeString);
        }
        private set;
    }

    public ColumnType cType {
        get {
            return ColumnType.valueOf(columnTypeString);
        }
        private set;
    }


    

}