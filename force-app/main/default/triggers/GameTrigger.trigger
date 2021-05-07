trigger GameTrigger on Game__c (after insert) {
    GameTriggerHandler.InitializeGame(Trigger.new);
}