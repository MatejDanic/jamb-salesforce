/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 27.5.2021.
 * ____________________________________________________________
 * 
 */

public with sharing class GameController {

    @auraEnabled
    public static String getGame(String gameId) {
        try {
            return GameService.getGame(gameId);
        } catch (Exception e) {
            System.debug(e.getMessage());       
            throw new AuraHandledException('Error (GameController.getGame): ' + e.getMessage());
        }
    }

    @auraEnabled
    public static String refreshGame(String gameId) {
        try {
            return GameService.refresh(gameId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException('Error (GameController.refreshGame): ' + e.getMessage());
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
    public static String announce(String gameId, String boxTypeString) {
        try {
            return GameService.announce(gameId, boxTypeString);
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