public with sharing class RecordUtil {
    public static Map<String, Object> recordToMap (String objectName, Object record) {
        Map<String, Object> returnMap = new Map<String, Object>();
        if (objectName == 'DICE') {
            Dice__c dice = (Dice__c) record;
            returnMap.put('value', dice.Value__c);
            returnMap.put('order', dice.Order__c);
            returnMap.put('held', dice.Held__c);
        }
        return returnMap;
    }
}
