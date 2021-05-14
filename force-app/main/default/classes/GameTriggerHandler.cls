public with sharing class GameTriggerHandler {

    public static void initializeGame(List<Game__c> gameList) {
        if (gameList.size() != 1) return;
        List<Dice__c> diceList = new List<Dice__c>();
        List<Column__c> columnList = new List<Column__c>();
        List<Box__c> boxList = new List<Box__c>();
        Game__c game = gameList[0];
        Integer numberOfDice = Integer.valueOf(game.Number_of_Dice__c);
        for (Integer i = 1; i <= numberOfDice; i++) {
            Dice__c dice = new Dice__c();
            dice.Game__c = game.Id;
            dice.Value__c = 6;
            dice.Order__c = i;
            diceList.add(dice);
        }
        Form__c form = new Form__c();
        form.Game__c = game.Id;
        insert form;
        insert diceList;

        Integer numberOfColumns = Integer.valueOf(game.Number_of_Columns__c);
        for (Integer i = 1; i <= numberOfColumns; i++) {
            Column__c column = new Column__c();
            column.Form__c = form.Id;
            column.Type__c = game.Column_Types__c == 'Classic' ? columnType.values()[i].name() : 'ANYDIRECTION';
            columnList.add(column);
            numberOfColumns--;
            if (numberOfColumns == 0) break;
        }
        insert columnList;

        for (Column__c column : columnList) {
            for (BoxType boxType : BoxType.values()) {
                Box__c box = new Box__c();
                box.Column__c = column.Id;
                box.Type__c = boxType.name();
                box.Filled__c = false;
                box.Available__c = (column.Type__c == 'DOWNWARDS' && box.Type__c == 'ONES'
                || column.Type__c == 'UPWARDS' && box.Type__c == 'YAHTZEE'
                || column.Type__c == 'ANYDIRECTION' && column.Type__c == 'ANNOUNCEMENT');
                box.Value__c = 0;
                boxList.add(box);
            }
        }
        insert boxList;
    }

    public static void generateScore(List<Game__c> gameList) {
        List<Score__c> scoreList = new List<Score__c>();
        for (Game__c game : gameList) {
            Score__c score = new Score__c();
            score.Value__c = game.Final_Sum__c;
            score.Date__c = Datetime.now();
            scoreList.add(score);
        }
        insert scoreList;
    }

}
