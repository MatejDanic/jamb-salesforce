public with sharing class GameController {

    @auraEnabled
    public static String getGameById(String gameId) {
        try {
            return GameService.getGameById(gameId);
        } catch (Exception e) {
            System.debug(e.getMessage());       
            throw new AuraHandledException('Error in GameController method "getGameById": ' + e.getMessage());
        }
    }

    @auraEnabled
    public static String rollDice(String gameId) {
        try {
            return GameService.rollDice(gameId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException('Error in GameController method "rollDice": ' + e.getMessage());
        }
    }

    @auraEnabled
    public static String holdDice(String gameId, Integer order) {
        try {
            return GameService.holdDice(gameId, order);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException('Error in GameController method "holdDice": ' + e.getMessage());
        }
    }

    @auraEnabled
    public static String announce(String gameId, String boxType) {
        try {
            return GameService.announce(gameId, boxType);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException('Error in GameController method "announce": ' + e.getMessage());
        }
    }
}