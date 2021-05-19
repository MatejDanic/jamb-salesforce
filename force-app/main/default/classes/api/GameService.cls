/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 17.5.2021.
 * @modified 19.5.2021.
 * ____________________________________________________________
 * 
*/

public with sharing class GameService {

    public static String getGameById(String gameId) {

        List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c, Dice__c, Form__c
                                FROM Game__c WHERE Id = :gameId];
        if (gameList.size() != 1) return null;
        Game__c game = gameList[0];

        return JSON.serialize(RecordUtil.recordToMap('GAME', game));
    }

    public static String rollDice(String gameId) {
        List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c, Dice__c, Form__c
                                FROM Game__c WHERE Id = :gameId];
        if (gameList.size() != 1) return null;
        Game__c game = gameList[0];

        List<Dice> diceList = (List<Dice>) JSON.deserialize(game.Dice__c, List<Dice>.class);

        if (game.Roll_Count__c == 0) {
            for (Dice dice : diceList) {
                dice.setHeld(false);
            }
        } else if (game.Roll_Count__c == 3) {
            throw new IllegalMoveException('Roll limit reached!');
        } else if (game.Roll_Count__c == 1 && game.Announcement__c == null && 
                    ((Form)JSON.deserialize(Game.Form__c, Form.class)).isAnnouncementRequired()) {
            throw new IllegalMoveException('Announcement is required!');
        }

        if (game.Roll_Count__c < 3) {
            game.Roll_Count__c = game.Roll_Count__c + 1;
        }

        for (Dice dice : diceList) {
            if (!dice.isHeld()) {
                dice.roll();
            }
        }
        game.Dice__c = JSON.serialize(diceList);
        update game;

        return game.Dice__c;
    }

    public static String holdDice(String gameId, Integer order) {
        List<Game__c> gameList = [SELECT Id, Dice__c FROM Game__c WHERE Id = :gameId];
        if (gameList.size() != 1) return null;
        Game__c game = gameList[0];

        List<Dice> diceList = (List<Dice>) JSON.deserialize(game.Dice__c, List<Dice>.class);
        for (Dice dice : diceList) {
            if (dice.getOrder() == order) {
                dice.setHeld(!dice.isHeld());
                break;
            }
        }
        game.Dice__c = JSON.serialize(diceList);
        update game;

        return game.Dice__c;
    }

    public static String announce(String gameId, String bType) {
        List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c
                                FROM Game__c WHERE Id = :gameId];
        if (gameList.size() != 1) return null;
        Game__c game = gameList[0];

        if (game.Announcement__c != null) {
            throw new IllegalMoveException('Announcement already declared!');
        } else if (game.Roll_Count__c != 1) {
            throw new IllegalMoveException('Announcement is available only after first roll!');
        }

        game.Announcement__c = bType;
        update game;

        return game.Announcement__c;
    }

    public static String fill(String gameId, String cType, String bType) {
        List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c,
                                    (SELECT Id FROM Forms__r)
                                FROM Game__c WHERE Id = :gameId LIMIT 1];
        if (gameList.size() != 1) return null;
        Game__c game = gameList[0];

        Form form = (Form)JSON.deserialize(game.Form__c, Form.class);
        List<Dice> diceList = (List<Dice>)JSON.deserialize(game.Dice__c, List<Dice>.class);
        
        Box b = form.getColumnByType(ColumnType.valueOf(cType)).getBoxByType(BoxType.valueOf(bType));
        
        if (b.isFilled()) {
			throw new IllegalMoveException('Box is already filled!');
        } else if (!b.isAvailable()) {
            throw new IllegalMoveException('Box is not available!');
        } else if (game.Roll_Count__c == 0) {
            throw new IllegalMoveException('Cannot fill box without rolling dice first!');
        } else if (game.Announcement__c != null && BoxType.valueOf(game.Announcement__c) != b.getType()) {
            throw new IllegalMoveException('Another box is announced');
        }

        for (Column column : form.getColumns()) {
            if (column.getType() == ColumnType.valueOf(cType)) {
                for (Box box : column.getBoxes()) {
                    if (box.getType() == BoxType.valueOf(bType)) {
                        box.fill(ScoreUtil.calculateScore(diceList, box.getType()));
                    } else if (column.getType() == ColumnType.DOWNWARDS && 
                    BoxType.valueOf(bType) != BoxType.YAHTZEE && 
                    BoxType.valueOf(bType).ordinal() + 1 == box.getType().ordinal()) {
                        box.setAvailable(true);
                    } else if (column.getType() == ColumnType.UPWARDS && 
                    BoxType.valueOf(bType) != BoxType.ONES && 
                    BoxType.valueOf(bType).ordinal() - 1 == box.getType().ordinal()) {
                        box.setAvailable(true);
                    }
                }   
                break;
            }
        }

        game.Form__c = JSON.serialize(form);
        update game;
        return game.Form__c;
    }
}
