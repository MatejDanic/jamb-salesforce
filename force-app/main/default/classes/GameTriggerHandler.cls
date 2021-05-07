public with sharing class GameTriggerHandler {

    public static void InitializeGame(List<Game__c> gameList) {
        List<Dice__c> diceList = new List<Dice__c>();
        List<Form__c> formList = new List<Form__c>();
        List<Column__c> columnList = new List<Column__c>();
        List<Box__c> boxList = new List<Box__c>();
        for (Game__c game : gameList) {
            for (Integer i=1; i<=5; i++) {
                Dice__c dice = new Dice__c();
                dice.Game__c = game.Id;
                dice.Value__c = 6;
                dice.Order__c = i;
                diceList.add(dice);
            }
            Form__c form = new Form__c();
            form.Game__c = game.Id;
            formList.add(form);
        }
        insert formList;
        insert diceList;

        for (Form__c form : formList) {
            for (ColumnType columnType : ColumnType.values()) {
                Column__c column = new Column__c();
                column.Form__c = form.Id;
                column.Type__c = columnType.name();
                columnList.add(column);
            }
        }
        insert columnList;

        for (Form__c form : formList) {
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
        }
        insert boxList;
    }
}
