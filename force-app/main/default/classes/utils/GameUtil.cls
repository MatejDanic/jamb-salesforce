public class GameUtil {

    public static Game__c getGameById(Id gameId) {
        return [
            SELECT Id, Game_String__c
            FROM Game__c
            WHERE Id = :gameId
        ];
    }

    public static Game getGameFromGameString(String gameString) {
        return (Game) JSON.deserialize(gameString, Game.class);
    }

    public static void initializeGameList(List<Game__c> gameList) {
        for (Game__c game : gameList) {
            initializeGame(game);
        }
    }

    public static Game__c initializeGame(Game__c game) {
        game.Game_String__c = JSON.serialize(new Game(generateForm(), generateDiceList()));
        return game;
    }

    private static Form generateForm() {
        Form form = new Form(generateColumnList());
        return form;
    }
    
    private static List<Dice> generateDiceList() {
        List<Dice> diceList = new List<Dice>();
        for (Integer i = 0; i < GameConstants.NUMBER_OF_DICE; i++) {
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

    private static Boolean isBoxAvailableAtStart(ColumnType cType, BoxType bType) {
        return cType == ColumnType.DOWNWARDS
                && bType == BoxType.ONES
            || cType == ColumnType.UPWARDS
                && bType == BoxType.YAMB
            || cType == ColumnType.FREE
            || cType == ColumnType.ANNOUNCEMENT;
    }

}