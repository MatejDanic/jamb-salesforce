public class Column implements Comparable {

    public ColumnType type { get; private set; }
    
    @AuraEnabled
    public transient String typeString { 
        get {
            return String.valueOf(type);
        }
        private set;
    }

    public Map<BoxType, Box> boxMap { get; private set; }    

    @AuraEnabled 
    public transient List<Box> boxList {
        get {
            List<Box> boxList = boxMap.values();
            boxList.sort();
            return boxList;
        }
        private set;
    }

    private transient List<Box> boxListUnsorted {
        get {
            return boxMap.values();
        }
        set;
    }

    @AuraEnabled
    public transient Integer topSectionSum {
        get {
            Integer topSectionSum = 0;
            for (BoxType bType : GameConstants.TOP_SECTION) {
                topSectionSum += boxMap.get(bType).value;
            }
            if (topSectionSum >= GameConstants.NUMBERSUM_BONUS_THRESHOLD) {
                topSectionSum += GameConstants.NUMBERSUM_BONUS;
            }
            return topSectionSum;
        }
        private set;
    }

    @AuraEnabled
    public transient Integer middleSectionSum { 
        get {
            Integer middleSectionSum = 0;
            Box ones = boxMap.get(BoxType.ONES);
            Box max = boxMap.get(BoxType.MAX);
            Box min = boxMap.get(BoxType.MIN);
            if (ones.filled && max.filled && min.filled) {
                middleSectionSum = ones.value * (max.value - min.value);
            }
            return middleSectionSum;
        }
        private set; 
    }

    @AuraEnabled
    public transient Integer bottomSectionSum { 
        get {
            Integer bottomSectionSum = 0;
            for (BoxType bType : GameConstants.BOTTOM_SECTION) {
                bottomSectionSum += boxMap.get(bType).value;
            }
            return bottomSectionSum;
        }
        private set; 
    }

    public transient Integer numOfAvailableBoxes {
        get {
            Integer numOfAvailableBoxes = 0;
            for (Box box : boxListUnsorted) {
                if (box.available) {
                    numOfAvailableBoxes += 1;
                }
            }
            return numOfAvailableBoxes;
        }
        private set;
    }
    
    public Column(ColumnType type, Map<BoxType, Box> boxMap) {
        this.type = type;
        this.boxMap = boxMap;
    }

    public Integer compareTo(Object compareTo) {
        Column compareToColumn = (Column) compareTo;
        return type.ordinal() - compareToColumn.type.ordinal();
    }

}