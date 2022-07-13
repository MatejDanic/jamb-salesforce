public with sharing class Box {
    public Integer value { get; private set; }
    public BoxType type { get; private set; }
    public Boolean isFilled { get; private set; }
    public Boolean isAvailable { get; private set; }

    public Box(BoxType type, Boolean isAvailable) {
        this.type = type;
        this.isAvailable = isAvailable;
        this.value = 0;
        this.isFilled = false;
        this.isAvailable = false;
    }

    public void fill(Integer value) {
        this.value = value;
        this.isFilled = true;
        this.isAvailable = false;
    }

    public Boolean isNext(
        ColumnType currentYambColumnType,
        BoxType currentYambBoxType
    ) {
        return (currentYambColumnType == ColumnType.DOWNWARDS &&
            currentYambBoxType != BoxType.YAMB &&
            currentYambBoxType.ordinal() + 1 == type.ordinal()) ||
            (currentYambColumnType == ColumnType.UPWARDS &&
            currentYambBoxType != BoxType.ONES &&
            currentYambBoxType.ordinal() - 1 == type.ordinal());
    }
}
