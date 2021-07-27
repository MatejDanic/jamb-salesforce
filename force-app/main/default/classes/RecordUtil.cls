/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 16.5.2021.
 * @modified 17.5.2021.
 * ____________________________________________________________
 * 
*/

public with sharing class RecordUtil {
    public static Map<String, Object> recordToMap (String objectName, Object record) {
        Map<String, Object> returnMap = new Map<String, Object>();
        if (objectName == 'GAME') {
            Game__c game = (Game__c) record;
            returnMap.put('rollCount', game.Roll_Count__c);
            returnMap.put('announcement', game.Announcement__c);
            returnMap.put('dice', JSON.deserializeUntyped(game.Dice__c));
            returnMap.put('form', JSON.deserializeUntyped(game.Form__c));
        }
        return returnMap;
    }
}