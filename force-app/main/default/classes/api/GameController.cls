public with sharing class GameController {
    @AuraEnabled
    public static Game__c getGameById(Id gameId) {
        try {
            return GameService.getGameById(gameId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Dice> rollDiceById(Id gameId) {
        try {
            return GameService.rollDiceById(gameId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static BoxType announceById(Id gameId, BoxType bType) {
        try {
            return GameService.announceById(gameId, bType);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Game__c fillById(Id gameId, ColumnType cType, BoxType bType) {
        try {
            return GameService.fillById(gameId, cType, bType);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Dice> toggleFreezeDiceById(Id gameId, Integer order) {
        try {
            return GameService.toggleFreezeDiceById(gameId, order);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
