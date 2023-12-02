public class GameService {

    public Game getGameByRecordId(Id gameId) {
        System.debug(gameId);
        Game__c gameRecord = getRecordById(gameId);
        Game gameObj = new Game();
        gameObj.mapFromSObject(gameRecord);
        return gameObj;
    }

    public Game rollDiceById(Id gameId, ActionRequest actionRequest) {
        System.debug(actionRequest);
        Game game = getGameByRecordId(gameId);
        game.rollDice(actionRequest.diceToRoll);
        Game__c gameRecord = new Game__c(Id = gameId);
        gameRecord = game.mapToSObject(gameRecord); 
        update gameRecord;
        return game;
    }

    public Game makeAnnouncementById(Id gameId, ActionRequest actionRequest) {
        System.debug(actionRequest);
        Game game = getGameByRecordId(gameId);
        game.makeAnnouncement(actionRequest.bType);
        Game__c gameRecord = new Game__c(Id = gameId);
        gameRecord = game.mapToSObject(gameRecord); 
        update gameRecord;
        return game;
    }

    public Game fillBoxById(Id gameId, ActionRequest actionRequest) {
        System.debug(actionRequest);
        Game game = getGameByRecordId(gameId);
        game.fillBox(actionRequest.cType, actionRequest.bType);
        if (game.status == GameStatus.FINISHED) {
            // Score__c score = new Score__c(
            //     game.sheet.totalSum
            // );
            // insert score;
        }
        Game__c gameRecord = new Game__c(Id = gameId);
        gameRecord = game.mapToSObject(gameRecord); 
        update gameRecord;
        return game;
    }

    public Game restartById(Id gameId) {
        Game game = getGameByRecordId(gameId);
        game.restart();
        Game__c gameRecord = new Game__c(Id = gameId);
        gameRecord = game.mapToSObject(gameRecord); 
        update gameRecord;
        return game;
    }

    private Game__c getRecordById(Id gameId) {
        return [
            SELECT 
                Id, Roll_Count__c, Announcement__c, 
                Sheet__c, Dices__c, Status__c 
            FROM Game__c 
            WHERE Id = :gameId
        ];
    }


}