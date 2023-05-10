public class Column {

    @AuraEnabled
    public ColumnType type { get; private set; }

    @AuraEnabled
    public List<Box> boxList { get; private set; }

    @AuraEnabled
    public Integer sum1 {
        get {
            Integer sum1 = 0;
            for (Box box : this.boxList) {
                if (box.isSection1()) {
                    sum1 += box.value;
                }
            }
            return sum1;
        }
        private set;
    }

    @AuraEnabled
    public Integer sum2 { 
        get {
            Integer sum2 = 0;
            Box ones = getBoxByType(BoxType.ONES);
            Box max = getBoxByType(BoxType.MAX);
            Box min = getBoxByType(BoxType.MIN);
            if (ones.filled && max.filled && min.filled) {
                sum2 = ones.value * (max.value - min.value);
            }
            return sum2;
        }
        private set; 
    }

    @AuraEnabled
    public Integer sum3 { 
        get {
            Integer sum3 = 0;
            for (Box box : this.boxList) {
                if (box.isSection3()) {
                    sum3 += box.value;
                }
            }
            return sum3;
        }
        private set; 
    }

    public Integer numOfAvailableBoxes {
        get {
            Integer numOfAvailableBoxes = 0;
            for (Box box : boxList) {
                if (box.available) {
                    numOfAvailableBoxes++;
                }
            }
            return numOfAvailableBoxes;
        }
        private set;
    }

    public Column(ColumnType type, List<Box> boxList) {
        this.type = type;
        this.boxList = boxList;
    }

    public Box getBoxByType(BoxType boxType) {
        for (Box box : this.boxList) {
            if (box.type == boxType) {
                return box;
            }
        }
        return null;
    }

    public Boolean isFinished() { 
        return numOfAvailableBoxes == 0;
    }

}