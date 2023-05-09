public class GameController {

    public static final GameService gameService = new GameService();

    @AuraEnabled
    public static Game resetGameById(Id gameId) {
        try {
            return gameService.resetGameById(gameId);
        } catch (Exception e) {
            Logger.error(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Dice> rollDiceByGameId(Id gameId, List<Integer> diceToRoll) {
        try {
            return gameService.rollDiceByGameId(gameId, diceToRoll);
        } catch (Exception e) {
            Logger.error(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static BoxType makeAnnouncementByGameId(Id gameId, String announcementBoxTypeString) {
        try {
            return gameService.makeAnnouncementByGameId(gameId, announcementBoxTypeString);
        } catch (Exception e) {
            Logger.error(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Game fillBoxByGameId(Id gameId, String columnTypeString, String boxTypeString) {
        Logger.debug(columnTypeString);
        Logger.debug(boxTypeString);
        try {
            return gameService.fillBoxByGameId(gameId, columnTypeString, boxTypeString);
        } catch (Exception e) {
            Logger.error(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

}