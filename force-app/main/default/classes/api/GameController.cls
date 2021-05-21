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

public with sharing class GameController {

    @auraEnabled
    public static String getGameById(String gameId) {
        try {
            return GameService.getGameById(gameId);
        } catch (Exception e) {
            System.debug(e.getMessage());       
            throw new AuraHandledException('Error (GameController.getGameById): ' + e.getMessage());
        }
    }

    @auraEnabled
    public static String rollDice(String gameId) {
        try {
            return GameService.rollDice(gameId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException('Error (GameController.rollDice): ' + e.getMessage());
        }
    }

    @auraEnabled
    public static String holdDice(String gameId, Integer order) {
        try {
            return GameService.holdDice(gameId, order);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException('Error (GameController.holdDice): ' + e.getMessage());
        }
    }

    @auraEnabled
    public static String announce(String gameId, String boxType) {
        try {
            return GameService.announce(gameId, boxType);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException('Error (GameController.announce): ' + e.getMessage());
        }
    }

    @auraEnabled
    public static String fill(String gameId, String columnTypeString, String boxTypeString) {
        try {
            return GameService.fill(gameId, columnTypeString, boxTypeString);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException('Error (GameController.fill): ' + e.getMessage());
        }
    }
}