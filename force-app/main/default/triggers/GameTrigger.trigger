trigger GameTrigger on Game__c (before insert, before delete) {
    if (Trigger.isInsert) {
        GameTriggerHandler.initializeGame(Trigger.new);
    } /*else if(Trigger.isDelete) {
        GameTriggerHandler.generateScore(Trigger.old);
    }*/
}