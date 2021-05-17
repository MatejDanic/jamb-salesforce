public with sharing class GameTriggerHandler {

    public static void initializeGame(List<Game__c> gameList) {
        if (gameList.size() != 1) return;

        Game__c game = gameList[0];

        // Map<String, Object> form = new Map<String, Object>();
        // List<Map<String, Object>> diceList = new List<Map<String, Object>>();
        // List<Map<String, Object>> columnList = new List<Map<String, Object>>();

        List<Dice> diceList = new List<Dice>();
        for (Integer i = 1; i <= Integer.valueOf(game.Number_of_Dice__c); i++) {
            Dice dice = new Dice(i);
            // Map<String, Object> dice = new Map<String, Object>();
            // dice.put('value', 6);
            // dice.put('order', i);
            // dice.put('held', false);
            diceList.add(dice);
        }
        game.Dice__c = JSON.serialize(diceList);

        List<Column> columnList = new List<Column>();
        for (Integer i = 1; i <= Integer.valueOf(game.Number_of_Columns__c); i++) {
            // Map<String, Object> column = new Map<String, Object>();
            // column.put('type', game.Column_Types__c == 'Classic' ? columnType.values()[i - 1].name() : 'ANYDIRECTION');
            // List<Map<String, Object>> boxList = new List<Map<String, Object>>();
            ColumnType cType = game.Column_Types__c == 'Classic' ? columnType.values()[i - 1] : ColumnType.ANYDIRECTION;
            List<Box> boxList = new List<Box>();
            for (BoxType bType : BoxType.values()) {
                Boolean available = (cType == ColumnType.DOWNWARDS && bType == BoxType.ONES
                || cType == ColumnType.UPWARDS && bType == BoxType.YAHTZEE
                || cType == ColumnType.ANYDIRECTION
                || cType == ColumnType.ANNOUNCEMENT);
                Box box = new Box(bType, available);
                // box.put('type', boxType.name());
                // box.put('filled', false);
                // box.put('available', column.type == 'DOWNWARDS' && box.type == 'ONES'
                // || column.type == 'UPWARDS' && box.type == 'YAHTZEE'
                // || column.type == 'ANYDIRECTION' 
                // || column.type == 'ANNOUNCEMENT');
                // box.put('value', 0);
                boxList.add(box);
            }
            
            Column column = new Column(cType, boxList);
            // column.put('boxes', boxList);
            columnList.add(column);
        }

        Form form = new Form(columnList);

        // form.put('columns', columnList);
        game.Form__c =  JSON.serialize(form);

        // List<Dice__c> diceList = new List<Dice__c>();
        // List<Column__c> columnList = new List<Column__c>();
        // List<Box__c> boxList = new List<Box__c>();
        // Game__c game = gameList[0];
        // Integer numberOfDice = Integer.valueOf(game.Number_of_Dice__c);
        // for (Integer i = 1; i <= numberOfDice; i++) {
        //     Dice__c dice = new Dice__c();
        //     dice.Game__c = game.Id;
        //     dice.Value__c = 6;
        //     dice.Order__c = i;
        //     dice.Held__c = false;
        //     diceList.add(dice);
        // }
        // Form__c form = new Form__c();
        // form.Game__c = game.Id;
        // insert form;
        // insert diceList;

        // Integer numberOfColumns = Integer.valueOf(game.Number_of_Columns__c);
        // for (Integer i = 1; i <= numberOfColumns; i++) {
        //     Column__c column = new Column__c();
        //     column.Form__c = form.Id;
        //     column.type = game.Column_Types__c == 'Classic' ? columnType.values()[i].name() : 'ANYDIRECTION';
        //     columnList.add(column);
        //     numberOfColumns--;
        //     if (numberOfColumns == 0) break;
        // }
        // insert columnList;

        // for (Column__c column : columnList) {
        //     for (BoxType boxType : BoxType.values()) {
        //         Box__c box = new Box__c();
        //         box.Column__c = column.Id;
        //         box.type = boxType.name();
        //         box.Filled__c = false;
        //         box.Available__c = column.type == 'DOWNWARDS' && box.type == 'ONES'
        //         || column.type == 'UPWARDS' && box.type == 'YAHTZEE'
        //         || column.type == 'ANYDIRECTION' 
        //         || column.type == 'ANNOUNCEMENT';
        //         box.Value__c = 0;
        //         boxList.add(box);
        //     }
        // }
        // insert boxList;
    }

    // public static void generateScore(List<Game__c> gameList) {
    //     List<Score__c> scoreList = new List<Score__c>();
    //     for (Game__c game : gameList) {
    //         Score__c score = new Score__c();
    //         score.Value__c = game.Final_Sum__c;
    //         score.Date__c = Datetime.now();
    //         scoreList.add(score);
    //     }
    //     insert scoreList;
    // }

}
