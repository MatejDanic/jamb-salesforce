public class GameService {

    public static final ApexLogger logger = ApexLogger.getLogger(GameService.class);

    public Sheet getSheetFromGameId(Id gameId) {
        Game__c game = GameUtil.getGameById(gameId);
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);
        logger.debug(JSON.serializePretty(sheet));
        return sheet;
    }

    public Sheet rollDiceByGameId(Id gameId, List<Integer> diceToRoll) {
        Game__c game = GameUtil.getGameById(gameId);
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);

        if (sheet.rollCount == 3) {
            throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_ROLL_LIMIT_REACHED);
        } else if (sheet.rollCount == 1 && sheet.announcement == null && sheet.announcementRequired) {
            throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_REQUIRED);
        }

        sheet.rollDice(diceToRoll);
        game.Sheet__c = JSON.serialize(sheet);
        update game;

        return sheet;
    }

    public Sheet fillBoxByGameId(Id gameId, String columnTypeString, String boxTypeString) {
        Game__c game = GameUtil.getGameById(gameId);
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);
        ColumnType cType = ColumnType.valueOf(columnTypeString);
        BoxType bType = BoxType.valueOf(boxTypeString);
        Box box = sheet.columnMap.get(cType).boxMap.get(bType);

        if (box.filled) {
            throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_BOX_ALREADY_FILLED);
        } else if (!box.available) {
			throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_BOX_NOT_AVAILABLE);
        } else if (sheet.rollCount == 0) {
			throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_DICE_ROLL_REQUIRED);
        } else if (sheet.announcement != null && (sheet.announcement != bType || cType != ColumnType.ANNOUNCEMENT)) {
			throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_BOX_NOT_ANNOUNCED);
        }

        sheet.fillBox(cType, bType);
        game.Sheet__c = JSON.serialize(sheet);
        update game;

        return sheet;
    }
    
    public Sheet makeAnnouncementByGameId(Id gameId, String boxTypeString) {
        Game__c game = GameUtil.getGameById(gameId);
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);
        BoxType announcementBoxType = BoxType.valueOf(boxTypeString);

        if (sheet.announcement != null) {
            throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_ALREADY_DECLARED);
        } else if (sheet.rollCount > 1) {
            throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_NOT_AVAILABLE);
        }

        sheet.makeAnnouncement(announcementBoxType);
        game.Sheet__c = JSON.serialize(sheet);
        update game;

        return sheet;
    }

    public Sheet restartByGameId(Id gameId) {
        Game__c game = GameUtil.getGameById(gameId);
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);

        if (sheet.completed) {
            throw new IllegalMoveException(GameConstants.ERROR_MESSAGE_RESTART_COMPLETED_SHEET);
        }

        GameUtil.initializeGame(game);
        update game;
        
        return GameUtil.getSheetFromString(game.Sheet__c);
    }
}