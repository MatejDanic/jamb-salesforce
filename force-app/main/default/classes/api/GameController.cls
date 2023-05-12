public class GameController {

    public static final GameService gameService = new GameService();
    public static final ApexLogger logger = ApexLogger.getLogger(GameService.class);

    @AuraEnabled(cacheable=true)
    public static Game getGameFromGameId(Id gameId) {
        try {
            return gameService.getGameFromGameId(gameId);
        } catch (Exception e) {
            logger.error(e);
            AuraHandledException exc = new AuraHandledException(e.getMessage());
            exc.setMessage(e.getMessage());
            throw exc;
        }
    }

    @AuraEnabled
    public static Game rollDiceByGameId(Id gameId, List<Integer> diceToRoll) {
        try {
            return gameService.rollDiceByGameId(gameId, diceToRoll);
        } catch (Exception e) {
            logger.error(e);
            AuraHandledException exc = new AuraHandledException(e.getMessage());
            exc.setMessage(e.getMessage());
            throw exc;
        }
    }

    @AuraEnabled
    public static Game fillBoxByGameId(Id gameId, String columnTypeString, String boxTypeString) {
        try {
            return gameService.fillBoxByGameId(gameId, columnTypeString, boxTypeString);
        } catch (Exception e) {
            logger.error(e);
            AuraHandledException exc = new AuraHandledException(e.getMessage());
            exc.setMessage(e.getMessage());
            throw exc;
        }
    }

    @AuraEnabled
    public static Game makeAnnouncementByGameId(Id gameId, String announcementString) {
        try {
            return gameService.makeAnnouncementByGameId(gameId, announcementString);
        } catch (Exception e) {
            logger.error(e);
            AuraHandledException exc = new AuraHandledException(e.getMessage());
            exc.setMessage(e.getMessage());
            throw exc;
        }
    }
    
    @AuraEnabled
    public static Game restartGameByGameId(Id gameId) {
        try {
            return gameService.restartGameByGameId(gameId);
        } catch (Exception e) {
            logger.error(e);
            AuraHandledException exc = new AuraHandledException(e.getMessage());
            exc.setMessage(e.getMessage());
            throw exc;
        }
    }

}