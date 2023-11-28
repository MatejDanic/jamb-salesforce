trigger GameTrigger on Game__c(before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        for (Game__c gameRecord : Trigger.New) {
            Game game = Game.getInstance();
            gameRecord = game.toSObject(gameRecord); 
        }
    }
}