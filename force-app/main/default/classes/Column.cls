/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 17.5.2021
 * @modified 5.6.2021
 * ____________________________________________________________
 * 
 */

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

    public Box getBoxByType(String boxTypeString) {
		for (Box box : this.boxes) {
			if (box.getType().name() == boxTypeString) {
				return box;
			}
		}
		return null;
	}

    public boolean isFinished() {
        for (Box box : this.boxes) {
            if (!box.isFilled()) {
                return false;
            }
        }
        return true;
    }

    public void updateSums() {
        this.numberSum = 0;
        this.differenceSum = 0;
        this.labelSum = 0;
        for (Box box : this.boxes) {
            if (box.getType() == BoxType.ONES || box.getType() == BoxType.TWOS || 
                box.getType() == BoxType.THREES || box.getType() == BoxType.FOURS || 
                box.getType() == BoxType.FIVES || box.getType() == BoxType.SIXES) {
                numberSum += box.getValue();
            } else if (box.getType() == BoxType.TRIPS || box.getType() == BoxType.STRAIGHT || 
                        box.getType() == BoxType.FULL_HOUSE || box.getType() == BoxType.CARRIAGE || 
                        box.getType() == BoxType.YAMB) {
                labelSum += box.getValue();
            }
        }
        Box ones = this.getBoxByType(String.valueOf(BoxType.ONES));
        Box max = this.getBoxByType(String.valueOf(BoxType.MAX));
        Box min = this.getBoxByType(String.valueOf(BoxType.MIN));
        if (ones.isFilled() && max.isFilled() && min.isFilled()) {
            this.differenceSum = ones.getValue() * (max.getValue() - min.getValue());
        }
    }
}