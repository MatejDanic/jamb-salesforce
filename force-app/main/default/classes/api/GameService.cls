public class GameService {

    public static final ApexLogger logger = ApexLogger.getLogger(GameService.class);

    public List<Dice> rollDiceByGameId(Id gameId, List<Integer> diceToRoll) {
        Game__c gameRecord = GameUtil.getGameById(gameId);
        Game game = GameUtil.getGameFromGameString(gameRecord.Game_String__c);

        if (game.rollCount == 3) {
            throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_ROLL_LIMIT_REACHED);
        } else if (game.rollCount == 1 && game.announcement == null && game.announcementRequired) {
            throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_REQUIRED);
        }

        game.rollDice(diceToRoll);
        gameRecord.Game_String__c = JSON.serialize(game);
        update gameRecord;

        return game.diceList;
    }

    public Box fillBoxByGameId(Id gameId, String columnTypeString, String boxTypeString) {
        Game__c gameRecord = GameUtil.getGameById(gameId);
        Game game = GameUtil.getGameFromGameString(gameRecord.Game_string__c);
        ColumnType cType = ColumnType.valueOf(columnTypeString);
        BoxType bType = BoxType.valueOf(boxTypeString);
        Box box = game.form.getColumnByType(cType).getBoxByType(bType);

        if (box.filled) {
            throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_BOX_ALREADY_FILLED);
        } else if (!box.available) {
			throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_BOX_NOT_AVAILABLE);
        } else if (game.rollCount == 0) {
			throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_DICE_ROLL_REQUIRED);
        } else if (game.announcement != null && (game.announcement != bType || cType != ColumnType.ANNOUNCEMENT)) {
			throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_BOX_NOT_ANNOUNCED);
        }

        game.fillBox(cType, bType);
        gameRecord.Game_String__c = JSON.serialize(game);
        update gameRecord;

        return game.form.getColumnByType(cType).getBoxByType(bType);
    }
    
    public BoxType makeAnnouncementByGameId(Id gameId, String announcementBoxTypeString) {
        Game__c gameRecord = GameUtil.getGameById(gameId);
        Game game = GameUtil.getGameFromGameString(gameRecord.Game_string__c);
        BoxType announcementBoxType = BoxType.valueOf(announcementBoxTypeString);

        if (game.announcement != null) {
            throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_ALREADY_DECLARED);
        } else if (game.rollCount > 1) {
            throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_NOT_AVAILABLE);
        }

        game.announcement = announcementBoxType;
        gameRecord.Game_String__c = JSON.serialize(game);
        update gameRecord;

        return game.announcement;
    }

    public Game restartGameById(Id gameId) {
        Game__c gameRecord = GameUtil.getGameById(gameId);
        Game game = GameUtil.getGameFromGameString(gameRecord.Game_string__c);

        if (game.form.isFinished()) {
            throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_RESTART_FINISHED_GAME);
        }

        GameUtil.initializeGame(gameRecord);
        update gameRecord;
        
        return GameUtil.getGameFromGameString(gameRecord.Game_String__c);
    }
}