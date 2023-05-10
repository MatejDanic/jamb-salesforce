trigger GameTrigger on Game__c(before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        GameUtil.initializeGameList(Trigger.new);
    }
}