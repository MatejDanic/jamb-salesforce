public class Box {
  @AuraEnabled
  public Integer value { get; private set; }
  @AuraEnabled
  public BoxType type { get; private set; }
  @AuraEnabled
  public Boolean filled { get; private set; }
  @AuraEnabled
  public Boolean available { get; set; }

  public Box(BoxType type, Boolean available) {
    this.type = type;
    this.available = available;
    this.value = 0;
    this.filled = false;
  }

  public void fill(Integer value) {
    this.value = value;
    this.filled = true;
    this.available = false;
  }

  public BoxType getNextBoxType(ColumnType cType) {
    BoxType nextBoxType;
    if (cType == ColumnType.DOWNWARDS && type != BoxType.YAMB) {
      nextBoxType = BoxType.values()[type.ordinal() + 1];
    } else if (cType == ColumnType.UPWARDS && Type != BoxType.ONES) {
      nextBoxType = BoxType.values()[type.ordinal() - 1];
    }
    return nextBoxType;
  }

  public Boolean isSection1() {
    return type == BoxType.ONES ||
      type == BoxType.TWOS ||
      type == BoxType.THREES ||
      type == BoxType.FOURS ||
      type == BoxType.FIVES ||
      type == BoxType.SIXES;
  }

  public Boolean isSection3() {
    return type == BoxType.TRIPS ||
      type == BoxType.STRAIGHT ||
      type == BoxType.BOAT ||
      type == BoxType.CARRIAGE ||
      type == BoxType.YAMB;
  }
}
