public with sharing class Column {
    public ColumnType type { get; private set; }
    private List<Box> boxList { get; private set; }
    public Integer sumA { get; private set; }
    public Integer sumB { get; private set; }
    public Integer sumC { get; private set; }

    public Column(ColumnType type, List<Box> boxList) {
        this.type = type;
        this.boxList = boxList;
        this.sumA = 0;
        this.sumB = 0;
        this.sumC = 0;
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
        for (Box box : this.boxList) {
            if (!box.isFilled) {
                return false;
            }
        }
        return true;
    }

    public void updateSums() {
        this.sumA = 0;
        this.sumB = 0;
        this.sumC = 0;
        for (Box box : this.boxList) {
            if (
                box.type == BoxType.ONES ||
                box.type == BoxType.TWOS ||
                box.type == BoxType.THREES ||
                box.type == BoxType.FOURS ||
                box.type == BoxType.FIVES ||
                box.type == BoxType.SIXES
            ) {
                sumA += box.value;
            } else if (
                box.type == BoxType.TRIPS ||
                box.type == BoxType.STRAIGHT ||
                box.type == BoxType.BOAT ||
                box.type == BoxType.CARRIAGE ||
                box.type == BoxType.YAMB
            ) {
                sumC += box.value;
            }
        }
        Box ones = this.getBoxByType(BoxType.ONES);
        Box max = this.getBoxByType(BoxType.MAX);
        Box min = this.getBoxByType(BoxType.MIN);
        if (ones.isFilled && max.isFilled && min.isFilled) {
            this.sumB = ones.value * (max.value - min.value);
        }
    }
}
