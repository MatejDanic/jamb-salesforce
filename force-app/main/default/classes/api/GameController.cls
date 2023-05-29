public class GameController {

    public static final ApexLogger logger = ApexLogger.getLogger(GameService.class);

    public static final GameService gameService = new GameService();

    @AuraEnabled(cacheable=true)
    public static Sheet getSheetFromGameId(Id gameId, Date lastModifiedDate) {
        try {
            return gameService.getSheetFromGameId(gameId);
        } catch (Exception e) {
            logger.error(e);
            AuraHandledException exc = new AuraHandledException(e.getMessage());
            exc.setMessage(e.getMessage());
            throw exc;
        }
    }

    @AuraEnabled
    public static Sheet rollDiceByGameId(Id gameId, List<Integer> diceToRoll) {
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
    public static Sheet fillBoxByGameId(Id gameId, String columnTypeString, String boxTypeString) {
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
    public static Sheet makeAnnouncementByGameId(Id gameId, String announcementString) {
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
    public static Sheet restartByGameId(Id gameId) {
        try {
            return gameService.restartByGameId(gameId);
        } catch (Exception e) {
            logger.error(e);
            AuraHandledException exc = new AuraHandledException(e.getMessage());
            exc.setMessage(e.getMessage());
            throw exc;
        }
    }

}