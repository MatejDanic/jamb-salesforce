public class Form {

    public Map<ColumnType, Column> columnMap { get; private set; }
    
    public Form(Map<ColumnType, Column> columnMap) {
        this.columnMap = columnMap;
    }

    @AuraEnabled
    public transient List<Column> columnList { 
        get {
            List<Column> columnList = columnMap.values();
            columnList.sort();
            return columnList;
        } 
        private set;
    }

    private transient List<Column> columnListUnsorted { 
        get {
            return columnMap.values();
        } 
        set;
    }

    @AuraEnabled
    public transient Integer topSectionSum { 
        get {
            Integer topSectionSum = 0;
            for (Column column : columnListUnsorted) {
                topSectionSum += column.topSectionSum;
            }
            return topSectionSum;
        }
        private set; 
    }

    @AuraEnabled
    public transient Integer middleSectionSum { 
        get {
            Integer middleSectionSum = 0;
            for (Column column : columnListUnsorted) {
                middleSectionSum += column.middleSectionSum;
            }
            return middleSectionSum;
        }
        private set; 
    }

    @AuraEnabled
    public transient Integer bottomSectionSum { 
        get {
            Integer bottomSectionSum = 0;
            for (Column column : columnListUnsorted) {
                bottomSectionSum += column.bottomSectionSum;
            }
            return bottomSectionSum;
        }
        private set; 
    }

    @AuraEnabled
    public transient Integer totalSum { 
        get{
            return topSectionSum + middleSectionSum + bottomSectionSum;
        }
        private set;
    }

    public transient Integer numOfAvailableBoxes {
        get { 
            Integer numOfAvailableBoxes = 0;
            for (Column column : columnListUnsorted) {
                numOfAvailableBoxes += column.numOfAvailableBoxes;
            }
            return numOfAvailableBoxes;
        }
        private set;
    }

}