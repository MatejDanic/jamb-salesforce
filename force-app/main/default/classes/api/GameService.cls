public with sharing class GameService {
    public static Game__c getGameById(Id gameId) {
        return Util.getGameById(gameId);
    }

    public static List<Dice> rollDiceById(Id gameId) {
        Game__c game = Util.getGameById(gameId);

        List<Dice> diceList = (List<Dice>) JSON.deserialize(
            game.Dice_List__c,
            List<Dice>.class
        );
        Form form = (Form) JSON.deserialize(game.Form__c, Form.class);

        if (game.Roll_Count__c == 0) {
            Util.resetDice(diceList);
        } else if (game.Roll_Count__c == 3) {
            throw new IllegalMoveException('Roll limit has been reached!');
        } else if (
            game.Roll_Count__c == 1 &&
            game.Announcement__c == null &&
            form.isAnnouncementRequired()
        ) {
            throw new IllegalMoveException('Announcement is required!');
        }

        Util.rollDice(diceList);
        game.Roll_Count__c = game.Roll_Count__c + 1;
        game.Dice_List__c = JSON.serialize(diceList);
        update game;

        return diceList;
    }

    public static List<Dice> toggleFreezeDiceById(Id gameId, Integer order) {
        Game__c game = Util.getGameById(gameId);
        List<Dice> diceList = (List<Dice>) JSON.deserialize(
            game.Dice_List__c,
            List<Dice>.class
        );

        for (Dice dice : diceList) {
            if (dice.order == order) {
                dice.toggleFreeze();
                break;
            }
        }

        game.Dice_List__c = JSON.serialize(diceList);
        update game;

        return diceList;
    }

    public static BoxType announceById(Id gameId, BoxType announcement) {
        Game__c game = Util.getGameById(gameId);

        if (game.Announcement__c != null) {
            throw new IllegalMoveException('Announcement is already declared!');
        } else if (game.Roll_Count__c != 1) {
            throw new IllegalMoveException(
                'Announcement is available only after first roll!'
            );
        }

        game.Announcement__c = announcement.name();
        update game;

        return BoxType.valueOf(game.Announcement__c);
    }

    public static Game__c fillById(Id gameId, ColumnType cType, BoxType bType) {
        Game__c game = Util.getGameById(gameId);
        Form form = (Form) JSON.deserialize(game.Form__c, Form.class);
        List<Dice> diceList = (List<Dice>) JSON.deserialize(
            game.Dice_List__c,
            List<Dice>.class
        );

        Box selectedBox = form.getColumnByType(cType).getBoxByType(bType);

        if (selectedBox.isFilled) {
            throw new IllegalMoveException('Box is already filled!');
        } else if (!selectedBox.isAvailable) {
            throw new IllegalMoveException('Box is currently unavailable!');
        } else if (game.Roll_Count__c == 0) {
            throw new IllegalMoveException('First roll is mandatory!');
        } else if (
            game.Announcement__c != null &&
            BoxType.valueOf(game.Announcement__c) != selectedBox.type
        ) {
            throw new IllegalMoveException(
                'Announcement is different from selected box!'
            );
        }

        selectedBox.fill(Util.calculateScore(diceList, bType));
        form.updateSums();

        if (form.isFinished()) {
            Score__c score = new Score__c(Value__c = form.totalSum);
            insert score;
        }

        game.Form__c = JSON.serialize(form);
        game.Dice_List__c = JSON.serialize(diceList);
        game.Roll_Count__c = 0;
        game.Announcement__c = null;
        update game;

        return game;
    }
}
