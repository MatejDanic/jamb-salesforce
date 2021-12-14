public with sharing class AvailabilityController {

    @AuraEnabled(cacheable=true)
    public static List<Account> getInventoryItemList(){
        try {
            return [SELECT Id, Name FROM Account LIMIT 50];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(List<Id> accountIdSet){
        try {
            return [SELECT Id, Name FROM Opportunity WHERE AccountId IN :accountIdSet LIMIT 50];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}