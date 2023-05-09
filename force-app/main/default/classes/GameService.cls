public class GameService {

    public Game resetGameById(Id gameId) {
        Game__c gameRecord = GameUtil.getGameById(gameId);
        GameUtil.initializeGame(gameRecord);
        update gameRecord;
        return GameUtil.getGameFromGameString(gameRecord.Game_String__c);
    }

    public List<Dice> rollDiceByGameId(Id gameId, List<Integer> diceToRoll) {
        Game__c gameRecord = GameUtil.getGameById(gameId);
        Game game = GameUtil.getGameFromGameString(gameRecord.Game_String__c);

        if (game.rollCount == 3) {
            throw new IllegalMoveException('Roll limit has been reached!');
        } else if (game.rollCount == 1 && game.announcement == null && game.announcementRequired) {
            throw new IllegalMoveException('Announcement is required!');
        }

        game.rollDice(diceToRoll);
        gameRecord.Game_String__c = JSON.serialize(game);
        update gameRecord;

        return game.diceList;
    }

    public BoxType makeAnnouncementByGameId(Id gameId, String announcementBoxTypeString) {
        Game__c gameRecord = GameUtil.getGameById(gameId);
        Game game = GameUtil.getGameFromGameString(gameRecord.Game_string__c);
        BoxType announcementBoxType = BoxType.valueOf(announcementBoxTypeString);

        if (game.announcement != null) {
            throw new IllegalMoveException('Announcement is already declared!');
        } else if (game.rollCount != 1) {
            throw new IllegalMoveException('Announcement is available only after first roll!');
        }

        game.announcement = announcementBoxType;
        gameRecord.Game_String__c = JSON.serialize(game);
        update gameRecord;

        return announcementBoxType;
    }

    public Game fillBoxByGameId(Id gameId, String columnTypeString, String boxTypeString) {
        Game__c gameRecord = GameUtil.getGameById(gameId);
        Game game = GameUtil.getGameFromGameString(gameRecord.Game_string__c);

        game.fillBox(ColumnType.valueOf(columnTypeString), BoxType.valueOf(boxTypeString));
        gameRecord.Game_String__c = JSON.serialize(game);
        update gameRecord;

        return game;
    }
}