public class GameUtil {

    public static Game__c getGameById(Id gameId) {
        return [
            SELECT Id, Sheet__c
            FROM Game__c
            WHERE Id = :gameId
        ];
    }

    public static Sheet getSheetFromString(String sheetString) {
        return (Sheet) JSON.deserialize(sheetString, Sheet.class);
    }

    public static void initializeGameList(List<Game__c> gameList) {
        for (Game__c game : gameList) {
            initializeGame(game);
        }
    }

    public static Game__c initializeGame(Game__c game) {
        game.Sheet__c = JSON.serialize(new Sheet(generateColumnMap(), generateDiceMap()));
        return game;
    }

    private static Map<Integer, Dice> generateDiceMap() {
        Map<Integer, Dice> diceMap = new Map<Integer, Dice>();
        for (Integer i = 0; i < GameConstants.NUMBER_OF_DICE; i++) {
            Dice dice = new Dice(i);
            diceMap.put(i, dice);
        }
        return diceMap;
    }
    
    private static Map<ColumnType, Column> generateColumnMap() {
        Map<ColumnType, Column> columnMap = new Map<ColumnType, Column>();
        for (ColumnType cType : ColumnType.values()) {
            Column column = new Column(cType, generateBoxMap(cType));
            columnMap.put(cType, column);
        }
        return columnMap;
    }
    

    private static Map<BoxType, Box> generateBoxMap(ColumnType cType) {
        Map<BoxType, Box> boxMap = new Map<BoxType, Box>();
        for (BoxType bType : BoxType.values()) {
            Box box = new Box(bType, isBoxAvailableAtStart(cType, bType));
            boxMap.put(bType, box);
        }
        return boxMap;
    }

    private static Boolean isBoxAvailableAtStart(ColumnType cType, BoxType bType) {
        return cType == ColumnType.DOWNWARDS
                && bType == BoxType.ONES
            || cType == ColumnType.UPWARDS
                && bType == BoxType.YAMB
            || cType == ColumnType.FREE
            || cType == ColumnType.ANNOUNCEMENT;
    }

}