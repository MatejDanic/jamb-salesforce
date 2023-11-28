public class GameController {

    public static final GameService gameService = new GameService();

    @AuraEnabled(cacheable=true)
    public static Game getGameByRecordId(Id gameId) {
        try {
            return gameService.getGameByRecordId(gameId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Game rollDiceById(Id gameId, ActionRequest actionRequest) {
        try {
            return gameService.rollDiceById(gameId, actionRequest);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Game fillBoxById(Id gameId, ActionRequest actionRequest) {
        try {
            return gameService.fillBoxById(gameId, actionRequest);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Game makeAnnouncementById(Id gameId, ActionRequest actionRequest) {
        try {
            return gameService.makeAnnouncementById(gameId, actionRequest);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Game restartById(Id gameId) {
        try {
            return gameService.restartById(gameId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}