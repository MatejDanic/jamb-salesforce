public with sharing class Column {
    
    private ColumnType type;
    private List<Box> boxes;
    private Integer numberSum;
    private Integer differenceSum;
    private Integer labelSum;

    public Column(ColumnType type, List<Box> boxes) {
        this.type = type;
        this.boxes = boxes;
        this.numberSum = 0;
        this.differenceSum = 0;
        this.labelSum = 0;
    }

    public ColumnType getType() {
        return this.type;
    }

    public void setType(ColumnType type) {
        this.type = type;
    }
    
    public List<Box> getBoxes() {
        return this.boxes;
    }

    public void setBoxes(List<Box> boxes) {
        this.boxes = boxes;
    }
    
    public Integer getNumberSum() {
        return this.numberSum;
    }

    public void setNumberSum(Integer numberSum) {
        this.numberSum = numberSum;
    }
    
    public Integer getDifferenceSum() {
        return this.differenceSum;
    }

    public void setDifferenceSum(Integer differenceSum) {
        this.differenceSum = differenceSum;
    }

    public Integer getLabelSum() {
        return this.labelSum;
    }

    public void setLabelSum(Integer labelSum) {
        this.labelSum = labelSum;
    }

}
