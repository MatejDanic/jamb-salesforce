public class Sheet {

    @AuraEnabled
    public List<Column> columns { get; private set; }

    private Sheet(List<Column> columns) {
        this.columns = columns;
    }

    public static Sheet getInstance() {
        return new Sheet(generateColumns());
    }

    @AuraEnabled
    public transient Integer topSectionSum { 
        get {
            Integer topSectionSum = 0;
            for (Column column : columns) {
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
            for (Column column : columns) {
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
            for (Column column : columns) {
                bottomSectionSum += column.bottomSectionSum;
            }
            return bottomSectionSum;
        }
        private set; 
    }

    @AuraEnabled
    public transient Integer totalSum { 
        get {
            return topSectionSum + middleSectionSum + bottomSectionSum;
        }
        private set;
    }

    public transient Boolean isCompleted {
        get {
            for (Column column : columns) {
                if (!column.isCompleted) {
                    return false;
                }
            }
            return true;
        }
        private set;
    }

    public void fillBox(ColumnType cType, BoxType bType, Integer value) {
        columns.get(cType.ordinal()).fillBox(bType, value);
    }

    public transient Boolean areAllNonAnnouncementColumnsCompleted {
        get {
            for (Column column : columns) {
                if (column.type != ColumnType.ANNOUNCEMENT && !column.isCompleted) {
                    return false;
                }
            }
            return true;
        }
        private set;
    }

    private static List<Column> generateColumns() {
        List<Column> columns = new List<Column>();
        for (ColumnType cType : ColumnType.values()) {
            columns.add(Column.getInstance(cType));
        }
        return columns;
    }
    
}