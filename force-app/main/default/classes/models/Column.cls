public class Column {

    public ColumnType type { get; private set; }
    
    @AuraEnabled
    public transient String typeString {
        get {
            return String.valueOf(type);
        }
        private set;
    }
    
    @AuraEnabled
    public List<Box> boxes { get; private set; } 
    
    private Column (ColumnType type, List<Box> boxes) {
        this.type = type; 
        this.boxes = boxes;
    }
    
    public static Column getInstance(ColumnType type) {
        return new Column(type, generateBoxes(type));
    }

    @AuraEnabled
    public transient Integer topSectionSum {
        get {
            Integer topSectionSum = 0;
            for (BoxType boxType : GameConstants.TOP_SECTION) {
                Box box = boxes.get(boxType.ordinal());
                if (box.value != null) {
                    topSectionSum += box.value;
                }
            }
            if (topSectionSum >= GameConstants.TOP_SECTION_SUM_BONUS_THRESHOLD) {
                topSectionSum += GameConstants.TOP_SECTION_SUM_BONUS;
            }
            return topSectionSum;
        }
        private set;
    }

    @AuraEnabled
    public transient Integer middleSectionSum { 
        get {
            Integer middleSectionSum = 0;
            Box ones = boxes.get(BoxType.ONES.ordinal());
            Box max = boxes.get(BoxType.MAX.ordinal());
            Box min = boxes.get(BoxType.MIN.ordinal());
            if (ones.value != null && max.value != null && min.value != null) {
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
            for (BoxType boxType : GameConstants.BOTTOM_SECTION) {
                Box box = boxes.get(boxType.ordinal());
                if (box.value != null) {
                    bottomSectionSum += box.value;
                }
            }
            return bottomSectionSum;
        }
        private set; 
    }

    public transient Integer numOfEmptyBoxes {
        get {
            Integer numOfEmptyBoxes = 0;
            for (Box box : boxes) {
                if (box.value == null) {
                    numOfEmptyBoxes += 1;
                }
            }
            return numOfEmptyBoxes;
        }
        private set;
    }    

    public transient Boolean isCompleted {
        get {
            return numOfEmptyBoxes == 0;
        }
        private set;

    }

    private static List<Box> generateBoxes(ColumnType columnType) {
        List<Box> boxes = new List<Box>();
        for (BoxType boxType : BoxType.values()) {
            boxes.add(Box.getInstance(boxType));
        }
        return boxes;
    }

    public void fillBox(BoxType boxType, Integer value) { 
        Box selectedBox = boxes.get(boxType.ordinal());
        selectedBox.fill(value);
    }

}