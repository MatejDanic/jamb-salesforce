public class Game {
  @AuraEnabled
  public Form form { get; private set; }
  @AuraEnabled
  public List<Dice> diceList { get; private set; }
  @AuraEnabled
  public Integer rollCount { get; set; }
  @AuraEnabled
  public BoxType announcement { get; set; }

  public Game(Form form, List<Dice> diceList) {
    this.form = form;
    this.diceList = diceList;
    rollCount = 0;
    announcement = null;
  }

  @AuraEnabled
  public Boolean announcementRequired {
    get {
      for (Column column : form.columnList) {
        if (column.type != ColumnType.ANNOUNCEMENT && !column.isFinished()) {
          return false;
        }
      }
      return true;
    }
    private set;
  }

  public void rollDice(List<Integer> diceToRoll) {
    for (Dice dice : diceList) {
      // always roll all dice for first roll
      if (diceToRoll.contains(dice.order) || rollCount == 0) {
        dice.roll();
      }
    }
    rollCount += 1;
  }

  public void fillBox(ColumnType cType, BoxType bType) {
    Box selectedBox = form.getColumnByType(cType).getBoxByType(bType);

    if (selectedBox.filled) {
      throw new IllegalMoveException('Box is already filled!');
    } else if (!selectedBox.available) {
      throw new IllegalMoveException('Box is currently unavailable!');
    } else if (rollCount == 0) {
      throw new IllegalMoveException('First roll is mandatory!');
    } else if (announcement != null && announcement != selectedBox.type) {
      throw new IllegalMoveException(
        'Announcement is different from selected box!'
      );
    }

    selectedBox.fill(GameUtil.calculateScore(diceList, bType));
    BoxType nextBoxType = selectedBox.getNextBoxType(cType);
    if (nextBoxType != null) {
      Box nextBox = form.getColumnByType(cType).getBoxByType(nextBoxType);
      nextBox.available = true;
    }

    rollCount = 0;
    announcement = null;

    // if (form.isFinished()) {
    //     Score__c score = new Score__c(Value__c = form.totalSum);
    //     insert score;
    // }
  }
}
