trigger GameTrigger on Game__c (after insert, before delete) {
    if (Trigger.isInsert) {
        GameTriggerHandler.initializeGame(Trigger.new);
    } else if(Trigger.isDelete) {
        GameTriggerHandler.generateScore(Trigger.old);
    }
}