public with sharing class GameController {

    @auraEnabled
    public static String getGameById(String gameId) {
        System.Debug(gameId);
        List<Game__c> gameQueryList = [SELECT Id, Announcement__c, Roll_Count__c,
                                    (SELECT Id, Value__c, Order__c FROM Dice__r),
                                    (SELECT Id, Number_Sum__c, Difference_Sum__c, Label_Sum__c, Final_Sum__c FROM Forms__r)
                                FROM Game__c WHERE Id = :gameId LIMIT 1];
                                
        Game__c game = gameQueryList[0];
        Form__c form = game.Forms__r[0];
        List<Column__c> columnQueryList = [SELECT Id, Type__c, Number_Sum__c, Difference_Sum__c, Label_Sum__c,
                                        (SELECT Id, Value__c, Type__c, Filled__c, Available__c FROM Boxes__r ORDER BY Type__c)
                                    FROM Column__c WHERE Form__c = :form.Id ORDER BY Type__c LIMIT 4];
        
        
        Map<String, Object> gameMap = new Map<String, Object>();
        System.Debug('Game:');
        gameMap.put('announcement', game.Announcement__c);
        gameMap.put('rollCount', game.Roll_Count__c);
        System.Debug(gameMap);
        List<Map<String, Object>> diceList = new List<Map<String, Object>>();
        
        System.Debug('Dice:');
        for (Dice__c dice : game.Dice__r) {
            Map<String, Object> diceMap = new Map<String, Object>();
            diceMap.put('value', dice.Value__c);
            diceMap.put('order', dice.Order__c);
            diceList.add(diceMap);
            System.Debug(diceMap);
        }
        gameMap.put('dice', diceList);

        Map<String, Object> formMap = new Map<String, Object>();
        List<Map<String, Object>> columnList = new List<Map<String, Object>>();
        
        System.Debug('Form:');
        for (Column__c column : columnQueryList) {
            Map<String, Object> columnMap = new Map<String, Object>();
            columnMap.put('type', column.Type__c);
            columnMap.put('numberSum', column.Number_Sum__c);
            columnMap.put('differenceSum', column.Difference_Sum__c);
            columnMap.put('labelSum', column.Label_Sum__c);
            System.Debug(columnMap);
            List<Map<String, Object>> boxList = new List<Map<String, Object>>();
            for (Box__c box : column.Boxes__r) {
                Map<String, Object> boxMap = new Map<String, Object>();
                boxMap.put('type', box.Type__c);
                boxMap.put('value', box.Value__c);
                boxMap.put('available', box.Available__c);
                boxMap.put('filled', box.Filled__c);
                boxList.add(boxMap);
                System.Debug(boxMap);
            }
            columnMap.put('boxes', boxList);
            columnList.add(columnMap);
        }
        formMap.put('numberSum', form.Number_Sum__c);
        formMap.put('differenceSum', form.Difference_Sum__c);
        formMap.put('labelSum', form.Label_Sum__c);
        formMap.put('finalSum', form.Final_Sum__c);
        formMap.put('columns', columnList);
        gameMap.put('form', formMap);

        return JSON.serialize(gameMap);
    }

    @auraEnabled
    public static List<Dice__c> rollDice(String gameId, List<Integer> diceToRoll) {
        List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c, Number_of_Columns__c, Number_of_Dice__c,
                                    (SELECT Id, Value__c, Order__c FROM Dice__r),
                                    (SELECT Id, Filled_Boxes__c FROM Forms__r)
                                FROM Game__c WHERE Id = :gameId LIMIT 1];
                                
        Game__c game = gameList[0];
        Form__c form = game.Forms__r[0];
        List<Dice__c> diceList = game.Dice__r;
        
		if (game.Roll_Count__c == 0) {
            diceToRoll = new List<Integer>();
            for (Integer i = 1; i <= Integer.valueOf(game.Number_of_Dice__c); i++) {
                diceToRoll.add(i);
            }
        } else if (game.Roll_Count__c == 3) {
            return null;
        } else if (game.Roll_Count__c == 1 && game.Announcement__c == null && Integer.valueOf(game.Number_of_Columns__c) == 4 && Integer.valueOf(form.Filled_Boxes__c) < (Integer.valueOf(game.Number_of_Columns__c) * 13)) {
            return null;
        }

		if (game.Roll_Count__c < 3) {
			game.Roll_Count__c = game.Roll_Count__c + 1;
		}

		for (Dice__c dice : diceList) {
            if (diceToRoll.contains(Integer.valueOf(dice.Order__c))) {
                dice.Value__c = Math.floor(Math.random() * ((6-1)+1) + 1);
            }
		}

        update game;
        update diceList;

		return diceList;
    }
}