/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 31.5.2021.
 * ____________________________________________________________
 * 
 */

public with sharing class GameController {

    @auraEnabled
    public static String refreshGame(String gameId) {
        try {
            return GameService.refresh(gameId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getTypeName() + '\n' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }

    @auraEnabled
    public static String rollDice(String gameId) {
        try {
            return GameService.rollDice(gameId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getTypeName() + '\n' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }

    @auraEnabled
    public static String holdDice(String gameId, Integer order) {
        try {
            return GameService.holdDice(gameId, order);
        } catch (Exception e) {
            throw new AuraHandledException(e.getTypeName() + '\n' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }

    @auraEnabled
    public static String announce(String gameId, String boxTypeString) {
        try {
            return GameService.announce(gameId, boxTypeString);
        } catch (Exception e) {
            throw new AuraHandledException(e.getTypeName() + '\n' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }

    @auraEnabled
    public static String fill(String gameId, String columnTypeString, String boxTypeString) {
        try {
            return GameService.fill(gameId, columnTypeString, boxTypeString);
        } catch (Exception e) {
            throw new AuraHandledException(e.getTypeName() + '\n' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }
}