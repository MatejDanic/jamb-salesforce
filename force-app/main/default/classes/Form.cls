public class Form {

    @AuraEnabled
    public List<Column> columnList { get; private set; }

    public Form() {
    }

    public Form(List<Column> columnList) {
        this.columnList = columnList;
    }

    @AuraEnabled
    public Integer sum1 { 
        get {
            Integer sum1 = 0;
            for (Column column : columnList) {
                sum1 += column.sum1;
            }
            return sum1;
        }
        private set; 
    }

    @AuraEnabled
    public Integer sum2 { 
        get {
            Integer sum2 = 0;
            for (Column column : columnList) {
                sum2 += column.sum2;
            }
            return sum2;
        }
        private set; 
    }

    @AuraEnabled
    public Integer sum3 { 
        get {
            Integer sum3 = 0;
            for (Column column : columnList) {
                sum3 += column.sum3;
            }
            return sum3;
        }
        private set; 
    }

    @AuraEnabled
    public Integer totalSum { 
        get{
            return sum1 + sum2 + sum3;
        }
        private set;
    }

    @AuraEnabled
    public Integer numOfAvailableBoxes {
        get { 
            Integer numOfAvailableBoxes = 0;
            for (Column column : columnList) {
                numOfAvailableBoxes += column.numOfAvailableBoxes;
            }
            return numOfAvailableBoxes;
        }
        private set;
    }

    public Column getColumnByType(ColumnType type) {
        Logger.entering();
        for (Column column : columnList) {
            if (column.type == type) {
                return column;
            }
        }
        Logger.exiting();
        return null;
    }

    public Boolean isFinished() {
        return numOfAvailableBoxes == 0;
    }

}