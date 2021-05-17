public with sharing class GameController {

    @auraEnabled
    public static String getGameById(String gameId) {

        List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c, Dice__c, Form__c
                                FROM Game__c WHERE Id = :gameId LIMIT 1];
        if (gameList.size() != 1) return null;
        Game__c game = gameList[0];

        Map<String, Object> gameMap = new Map<String, Object>();
        gameMap.put('rollCount', game.Roll_Count__c);
        gameMap.put('announcement', game.Announcement__c);
        gameMap.put('dice', JSON.deserializeUntyped(game.Dice__c));
        gameMap.put('form', JSON.deserializeUntyped(game.Form__c));
        
        return JSON.serialize(gameMap);
        
        // List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c,
        //                             (SELECT Id, Value__c, Order__c, Held__c FROM Dice__r),
        //                             (SELECT Id, Number_Sum__c, Difference_Sum__c, Label_Sum__c, Final_Sum__c FROM Forms__r)
        //                         FROM Game__c WHERE Id = :gameId LIMIT 1];
        // if (gameList.size() != 1) return null;
  
        // Game__c game = gameList[0];
        // Form__c form = game.Forms__r[0];

        // List<Column__c> columnRecordList = [SELECT Id, Type__c, Number_Sum__c, Difference_Sum__c, Label_Sum__c,
        //                                 (SELECT Id, Value__c, Type__c, Filled__c, Available__c FROM Boxes__r ORDER BY Type__c)
        //                             FROM Column__c WHERE Form__c = :form.Id ORDER BY Type__c LIMIT 4];
        
        
        // Map<String, Object> gameMap = new Map<String, Object>();
        // System.Debug('Game:');
        // // gameMap.put('announcement', game.Announcement__c);
        // gameMap.put('rollCount', game.Roll_Count__c);
        // System.Debug(gameMap);
        // List<Map<String, Object>> diceList = new List<Map<String, Object>>();
        // for (Dice__c dice : game.Dice__r) {
        //     diceList.add(RecordUtil.recordToMap('DICE', dice));
        // }
        // gameMap.put('dice', diceList);

        // Map<String, Object> formMap = new Map<String, Object>();
        // List<Map<String, Object>> columnList = new List<Map<String, Object>>();
        
        // System.Debug('Form:');
        // for (Column__c column : columnRecordList) {

        //     Map<String, Object> columnMap = new Map<String, Object>();
        //     columnMap.put('type', column.Type__c);
        //     columnMap.put('numberSum', column.Number_Sum__c);
        //     columnMap.put('differenceSum', column.Difference_Sum__c);
        //     columnMap.put('labelSum', column.Label_Sum__c);
        //     System.Debug(columnMap);

        //     List<Map<String, Object>> boxList = new List<Map<String, Object>>();
        //     for (Box__c box : column.Boxes__r) {
        //         Map<String, Object> boxMap = new Map<String, Object>();
        //         boxMap.put('type', box.Type__c);
        //         boxMap.put('value', box.Value__c);
        //         boxMap.put('available', box.Available__c);
        //         boxMap.put('filled', box.Filled__c);
        //         boxList.add(boxMap);
        //         System.Debug(boxMap);
        //     }
        //     columnMap.put('boxes', boxList);
        //     columnList.add(columnMap);
        // }
        // formMap.put('numberSum', form.Number_Sum__c);
        // formMap.put('differenceSum', form.Difference_Sum__c);
        // formMap.put('labelSum', form.Label_Sum__c);
        // formMap.put('finalSum', form.Final_Sum__c);
        // formMap.put('columns', columnList);
        // gameMap.put('form', formMap);
        // return JSON.serialize(gameMap);
    }

    @auraEnabled
    public static String rollDice(String gameId) {

        List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c, Number_of_Columns__c, Number_of_Dice__c,
                                    (SELECT Id, Held__c, Value__c, Order__c FROM Dice__r),
                                    (SELECT Id, Filled_Boxes__c FROM Forms__r)
                                FROM Game__c WHERE Id = :gameId LIMIT 1];
        if (gameList.size() != 1) return null;
        
        Game__c game = gameList[0];
        Form__c form = game.Forms__r[0];

        List<Column__c> columnList = [SELECT Id, Type__c,
                                        (SELECT Id, Type__c, Available__c FROM Boxes__r ORDER BY Type__c LIMIT 13)
                                    FROM Column__c WHERE Form__c = :form.Id ORDER BY Type__c LIMIT 4];
        
        List<Dice__c> diceList = game.Dice__r;
        
		if (game.Roll_Count__c == 0) {
            for (Dice__c dice : diceList) {
                dice.Held__c = false;
            }
        } else if (game.Roll_Count__c == 3) {
            throw new IllegalMoveException('Roll limit reached!');
        } else if (game.Roll_Count__c == 1 && game.Announcement__c == null && GameUtil.isAnnouncementRequired(columnList)) {
            throw new IllegalMoveException('Announcement is required!');
        }

		if (game.Roll_Count__c < 3) {
			game.Roll_Count__c = game.Roll_Count__c + 1;
		}
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();

		for (Dice__c dice : diceList) {
            if (!dice.Held__c) {
                dice.Value__c = Math.floor(Math.random() * ((6-1)+1) + 1);
            }
            returnList.add(RecordUtil.recordToMap('DICE', dice));
		}
        update game;
        update diceList;

        return JSON.serialize(returnList);
    }

    @auraEnabled
    public static String holdDice(String gameId, Integer order) {
        List<Dice__c> diceList = [SELECT Id, Held__c, Value__c, Order__c FROM Dice__c WHERE Game__c = :gameId AND Order__c = :order LIMIT 1];
        if (diceList.size() != 1) return null;
        Dice__c dice = diceList[0];
        dice.Held__c = !dice.Held__c;
        update dice;
        return JSON.serialize(RecordUtil.recordToMap('DICE', dice));
    }

    @auraEnabled
    public static String announce(String gameId, String boxType) {
        List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c,
                                    (SELECT Id FROM Forms__r)
                                FROM Game__c WHERE Id = :gameId LIMIT 1];
        if (gameList.size() != 1) return null;
        
        Game__c game = gameList[0];
        Form__c form = game.Forms__r[0];

        List<Column__c> columnList = [SELECT Id, Type__c,
                                        (SELECT Id, Type__c, Filled__c, Available__c FROM Boxes__r ORDER BY Type__c)
                                    FROM Column__c WHERE Form__c = :form.Id ORDER BY Type__c LIMIT 4];

        if (game.Announcement__c != null) {
            throw new IllegalMoveException('Announcement already declared!');
        } else if (game.Roll_Count__c != 1) {
            throw new IllegalMoveException('Announcement is available only after first roll!');
        }

        game.Announcement__c = boxType;
        update game;
        return JSON.serialize(game.Announcement__c);
    }


}