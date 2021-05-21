/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 21.5.2021.
 * ____________________________________________________________
 * 
 */

public with sharing class GameTriggerHandler {

    public static void initializeGame(List<Game__c> gameList) {
        if (gameList.size() != 1) return;

        Game__c game = gameList[0];

        List<Dice> diceList = new List<Dice>();
        for (Integer i = 1; i <= Integer.valueOf(game.Number_of_Dice__c); i++) {
            Dice dice = new Dice(i);
            diceList.add(dice);
        }
        game.Dice__c = JSON.serialize(diceList);

        List<Column> columnList = new List<Column>();
        for (Integer i = 1; i <= Integer.valueOf(game.Number_of_Columns__c); i++) {
            ColumnType cType = game.Column_Types__c == 'Classic' ? columnType.values()[i - 1] : ColumnType.ANYDIRECTION;
            List<Box> boxList = new List<Box>();
            for (BoxType bType : BoxType.values()) {
                Boolean available = (cType == ColumnType.DOWNWARDS && bType == BoxType.ONES
                || cType == ColumnType.UPWARDS && bType == BoxType.YAHTZEE
                || cType == ColumnType.ANYDIRECTION
                || cType == ColumnType.ANNOUNCEMENT);
                Box box = new Box(bType, available);
                boxList.add(box);
            }
            
            Column column = new Column(cType, boxList);
            columnList.add(column);
        }
        Form form = new Form(columnList);
        game.Form__c =  JSON.serialize(form);
    }

    public static void generateScore(List<Game__c> gameList) {
        List<Score__c> scoreList = new List<Score__c>();
        for (Game__c game : gameList) {
            if (game.Finished__c) {
                Score__c score = new Score__c(Value__c = game.Final_Sum__c, Date__c = DateTime.now());
                scoreList.add(new Score__c(Value__c = game.Final_Sum__c, Date__c = DateTime.now()));
            }
        }
        insert scoreList;
    }
}
