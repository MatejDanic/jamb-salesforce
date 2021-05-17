public with sharing class GameService {

    public static String getGameById(String gameId) {

        List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c, Dice__c, Form__c
                                FROM Game__c WHERE Id = :gameId LIMIT 1];
        if (gameList.size() != 1) return null;
        Game__c game = gameList[0];

        return JSON.serialize(RecordUtil.recordToMap('GAME', game));
    }

    public static String rollDice(String gameId) {
        List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c, Dice__c, Form__c
                                FROM Game__c WHERE Id = :gameId LIMIT 1];
        if (gameList.size() != 1) return null;
        Game__c game = gameList[0];

        List<Dice> diceList = (List<Dice>) JSON.deserialize(game.Dice__c, List<Dice>.class);

        if (game.Roll_Count__c == 0) {
            for (Dice dice : diceList) {
                dice.setHeld(false);
            }
        } else if (game.Roll_Count__c == 3) {
            throw new IllegalMoveException('Roll limit reached!');
        } else if (game.Roll_Count__c == 1 && game.Announcement__c == null && GameUtil.isAnnouncementRequired((Form)JSON.deserialize(Game.Form__c, Form.class))) {
            throw new IllegalMoveException('Announcement is required!');
        }

        if (game.Roll_Count__c < 3) {
            game.Roll_Count__c = game.Roll_Count__c + 1;
        }

        for (Dice dice : diceList) {
            if (!dice.isHeld()) {
                dice.setValue(Math.round(Math.random() * (6-1) + 1));
            }
        }
        game.Dice__c = JSON.serialize(diceList);
        update game;

        return game.Dice__c;
    }

    public static String holdDice(String gameId, Integer order) {
        List<Game__c> gameList = [SELECT Id, Dice__c FROM Game__c WHERE Id = :gameId LIMIT 1];
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

    public static String announce(String gameId, String boxType) {
        List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c,
                                    (SELECT Id FROM Forms__r)
                                FROM Game__c WHERE Id = :gameId LIMIT 1];
        if (gameList.size() != 1) return null;
        
        Game__c game = gameList[0];
        Form__c form = game.Forms__r[0];

        List<Column__c> columnList = [SELECT Id, Type__c,
                                        (SELECT Id, Type__c, Filled__c, Available__c FROM Boxes__r ORDER BY Type__c)
                                    FROM Column__c WHERE Form__c = :form.Id ORDER BY Type__c LIMIT 4];

        if (game.Announcement__c != null) {
            throw new IllegalMoveException('Announcement already declared!');
        } else if (game.Roll_Count__c != 1) {
            throw new IllegalMoveException('Announcement is available only after first roll!');
        }

        game.Announcement__c = boxType;
        update game;
        return JSON.serialize(game.Announcement__c);
    }


}
