public with sharing class GameController {

    @auraEnabled
    public static String getGameById(String gameId) {
        List<Game__c> gameQueryList = [SELECT Id, Announcement__c, Roll_Count__c,
                                    (SELECT Id, Value__c, Order__c FROM Dice__r),
                                    (SELECT Id FROM Forms__r)
                                FROM Game__c WHERE Id = :gameId LIMIT 1];
                                
        Game__c game = gameQueryList[0];
        Form__c form = game.Forms__r[0];
        List<Column__c> columnQueryList = [SELECT Id, Type__c,
                                        (SELECT Id, Type__c, Value__c, Filled__c, Available__c FROM Boxes__r ORDER BY Type__c)
                                    FROM Column__c WHERE Form__c = :form.Id ORDER BY Type__c LIMIT 4];
        
        
        Map<String, Object> gameMap = new Map<String, Object>();
        System.Debug('Game:');
        gameMap.put('announcement', game.Announcement__c);
        gameMap.put('roll_count', game.Roll_Count__c);
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
        formMap.put('columns', columnList);
        gameMap.put('form', formMap);

        return JSON.serialize(gameMap);
    }
}