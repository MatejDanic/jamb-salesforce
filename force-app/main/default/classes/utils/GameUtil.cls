public class GameUtil {
  public static Game__c getGameById(Id gameId) {
    return [SELECT Id, Game_String__c FROM Game__c WHERE Id = :gameId];
  }

  public static Integer calculateScore(List<Dice> diceList, BoxType bType) {
    Integer result = 0;
    switch on bType {
      when ONES, TWOS, THREES, FOURS, FIVES, SIXES {
        result = calculateSumByType(diceList, bType);
      }
      when MAX, MIN {
        result = calculateSum(diceList);
      }
      when TRIPS {
        result = calculateSumOfRepeatingValue(
          diceList,
          3,
          Constants.BONUS_TRIPS
        );
      }
      when STRAIGHT {
        result = calculateStraight(diceList);
      }
      when BOAT {
        result = calculateFullHouse(diceList, Constants.BONUS_BOAT);
      }
      when CARRIAGE {
        result = calculateSumOfRepeatingValue(
          diceList,
          4,
          Constants.BONUS_CARRIAGE
        );
      }
      when YAMB {
        result = calculateSumOfRepeatingValue(
          diceList,
          5,
          Constants.BONUS_YAMB
        );
      }
    }
    return result;
  }

  private static Integer calculateSum(List<Dice> diceList) {
    Integer sum = 0;
    for (Dice dice : diceList) {
      sum += dice.value;
    }
    return sum;
  }

  private static Integer calculateSumByType(
    List<Dice> diceList,
    BoxType bType
  ) {
    Integer sum = 0;
    for (Dice dice : diceList) {
      if ((dice.value - 1) == bType.ordinal()) {
        sum += dice.value; // if dice value is equal to box type add to sum
      }
    }
    return sum;
  }

  private static Integer calculateSumOfRepeatingValue(
    List<Dice> diceList,
    Integer repeatNumber,
    Integer bonus
  ) {
    Integer sum = 0;
    for (Integer i = 1; i <= 6; i++) {
      Integer count = 0;
      for (Dice dice : diceList) {
        if (dice.value == i) {
          count++;
        }
      }
      if (count >= repeatNumber) {
        // if count has reached given number return sum increased by given bonus
        sum = i * repeatNumber + bonus; // multiply by repeat number instead of count
        break;
      }
    }
    return sum; // if count has not reached given number for any dice value return 0
  }

  private static Integer calculateStraight(List<Dice> diceList) {
    Boolean hasElements = false;
    for (Integer i = 2; i <= 5; i++) {
      hasElements = false;
      for (Dice dice : diceList) {
        if (dice.value == i) {
          hasElements = true;
          break;
        }
      }
      if (!hasElements) {
        break;
      }
    }
    if (hasElements) {
      for (Dice dice : diceList) {
        if (dice.value == 1) {
          return Constants.BONUS_STRAIGHT_SMALL;
        } else if (dice.value == 6) {
          return Constants.BONUS_STRAIGHT_BIG;
        }
      }
    }
    return 0;
  }

  private static Integer calculateFullHouse(
    List<Dice> diceList,
    Integer bonus
  ) {
    Integer valueOfPair = 0;
    Integer valueOfTrips = 0;
    for (Integer i = 1; i <= 6; i++) {
      Integer count = 0;
      for (Dice dice : diceList) {
        if (dice.value == i) {
          count++;
        }
      }
      if (count == 2) {
        valueOfPair = i * 2;
      } else if (count == 3) {
        if (valueOfTrips > i * 3) {
          valueOfPair = i * 2;
        } else {
          if (valueOfTrips > 0) {
            valueOfPair = valueOfTrips * 2 / 3;
          }
          valueOfTrips = i * 3;
        }
      }
    }
    if (valueOfPair > 0 && valueOfTrips > 0) {
      return valueOfPair + valueOfTrips + bonus;
    }
    return 0;
  }

  public static void initializeGameList(List<Game__c> gameList) {
    for (Game__c game : gameList) {
      initializeGame(game);
    }
  }

  public static Game__c initializeGame(Game__c game) {
    game.Game_String__c = JSON.serialize(
      new Game(generateForm(), generateDiceList())
    );
    return game;
  }

  private static Form generateForm() {
    Form form = new Form(generateColumnList());
    return form;
  }

  private static List<Dice> generateDiceList() {
    List<Dice> diceList = new List<Dice>();
    for (Integer i = 0; i < Constants.NUMBER_OF_DICE; i++) {
      Dice dice = new Dice(i);
      diceList.add(dice);
    }
    return diceList;
  }

  private static List<Column> generateColumnList() {
    List<Column> columnList = new List<Column>();
    for (ColumnType cType : ColumnType.values()) {
      Column column = new Column(cType, generateBoxList(cType));
      columnList.add(column);
    }
    return columnList;
  }

  private static List<Box> generateBoxList(ColumnType cType) {
    List<Box> boxList = new List<Box>();
    for (BoxType bType : BoxType.values()) {
      Box box = new Box(bType, isBoxAvailableAtStart(cType, bType));
      boxList.add(box);
    }
    return boxList;
  }

  private static Boolean isBoxAvailableAtStart(
    ColumnType cType,
    BoxType bType
  ) {
    return cType == ColumnType.DOWNWARDS &&
      bType == BoxType.ONES ||
      cType == ColumnType.UPWARDS &&
      bType == BoxType.YAMB ||
      cType == ColumnType.FREE ||
      cType == ColumnType.ANNOUNCEMENT;
  }

  public static Game getGameFromGameString(String gameString) {
    return (Game) JSON.deserialize(gameString, Game.class);
  }
}
