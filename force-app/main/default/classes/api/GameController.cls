public class GameController {

    public static final GameService gameService = new GameService();
    public static final ApexLogger logger = ApexLogger.getLogger(GameService.class);

    @AuraEnabled
    public static List<Dice> rollDiceByGameId(Id gameId, List<Integer> diceToRoll) {
        try {
            return gameService.rollDiceByGameId(gameId, diceToRoll);
        } catch (Exception e) {
            logger.error(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Game fillBoxByGameId(Id gameId, String columnTypeString, String boxTypeString) {
        try {
            return gameService.fillBoxByGameId(gameId, columnTypeString, boxTypeString);
        } catch (Exception e) {
            logger.error(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static BoxType makeAnnouncementByGameId(Id gameId, String announcementBoxTypeString) {
        try {
            return gameService.makeAnnouncementByGameId(gameId, announcementBoxTypeString);
        } catch (Exception e) {
            logger.error(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Game restartGameById(Id gameId) {
        try {
            return gameService.restartGameById(gameId);
        } catch (Exception e) {
            logger.error(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

}