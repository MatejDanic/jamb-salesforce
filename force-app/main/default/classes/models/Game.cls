public class Game {
    
    @AuraEnabled
    public Sheet gameSheet { get; private set; }

    @AuraEnabled
    public List<Dice> dices { get; private set; }

    @AuraEnabled 
    public Integer rollCount { get; private set; }

    public BoxType announcement { get; private set; }
    
    @AuraEnabled
    public transient String announcementString {
        get {
            return String.valueOf(announcement);
        }
        private set;
    }

    public GameStatus status { get; private set; }

    @AuraEnabled
    public transient String statusString {
        get {
            return String.valueOf(statusString);
        }
        private set;
    }

    private Game(Sheet gameSheet, List<Dice> dices, Integer rollCount, BoxType announcement, GameStatus status) {
        this.gameSheet = gameSheet;
        this.dices = dices;
        this.rollCount = rollCount;
        this.announcement = announcement;
        this.status = status;
    }

    public static Game getInstance() {
        return new Game(Sheet.getInstance(), generateDices(), 0, null, GameStatus.IN_PROGRESS);
    }

    public static Game fromSObject(Game__c game) {
        return new Game(
            (Sheet) JSON.deserialize(game.Sheet__c, Sheet.class),
            (List<Dice>) JSON.deserialize(game.Dices__c, List<Dice>.class),
            Integer.valueOf(game.Roll_Count__c),
            game.Announcement__c != null ? BoxType.valueOf(game.Announcement__c) : null,
            GameStatus.valueOf(game.Status__c)
        );
    }

    public Game__c toSObject(Game__c game) {
        game.Sheet__c = JSON.serialize(gameSheet);
        game.Dices__c = JSON.serialize(dices);
        game.Roll_Count__c = rollCount;
        game.Announcement__c = announcementString;
        game.Status__c = statusString;
        return game;
    }

    private static List<Dice> generateDices() {
        List<Dice> dices = new List<Dice>();
        for (Integer i = 0; i < GameConstants.DICE_LIMIT; i++) {
            dices.add(Dice.getInstance(i));
        }
        return dices;
    }

    public boolean isAnnouncementRequired { 
        get {
            return rollCount == 1 && announcement == null && gameSheet.areAllNonAnnouncementColumnsCompleted;
        }
        private set;
    }
    
    public void rollDice(Integer[] diceToRoll) {
        validateRollAction();
        // always roll all dice for the first roll
        if (rollCount == 0) {
            for (Dice dice : dices) {
                dice.roll();
            }
        } else {
            for (Integer index : diceToRoll) {
                Dice dice = dices.get(index);
                dice.roll();
            }
        }
        rollCount += 1;
    }

    public Integer[] diceValues {
        get {
            Integer[] diceValues = new Integer[GameConstants.DICE_LIMIT];
            for(Dice dice : dices) {
                diceValues.add(dice.value);
            }
            return diceValues;
        }
        private set;
    }
    
    public void fillBox(ColumnType cType, BoxType bType) {
        validateFillBoxAction(cType, bType);
        gameSheet.fillBox(cType, bType, ScoreCalculator.calculateScore(diceValues, bType));
        if (gameSheet.isCompleted) {
            status = GameStatus.FINISHED;
        }
        rollCount = 0;
        announcement = null;
    }
    
    public void makeAnnouncement(BoxType bType) {
        validateAnnouncementAction(bType);
        announcement = bType;
    }

    public void restart() {
        validateRestartAction();
        rollCount = 0;
        announcement = null;
        gameSheet = Sheet.getInstance();
        dices = generateDices();
    }

    private void validateRollAction() {
        if (rollCount == 3) {
            throw new RollLimitExceededException(MessageConstants.ERROR_ROLL_LIMIT_EXCEEDED);
        } else if (isAnnouncementRequired) {
            throw new AnnouncementRequiredException(MessageConstants.ERROR_ANNOUNCEMENT_REQUIRED);
        }
    }

    private void validateFillBoxAction(ColumnType cType, BoxType bType) {
        if (rollCount == 0) {
			throw new DiceRollRequiredException(MessageConstants.ERROR_DICE_ROLL_REQUIRED);
        } else if (!isBoxAvailable(cType, bType)) {
            throw new BoxUnavailableException(MessageConstants.ERROR_BOX_NOT_AVAILABLE);
        }
    }

    private void validateAnnouncementAction(BoxType bType) {
        if (announcement != null) {
            throw new AnnouncementAlreadyDeclaredException(MessageConstants.ERROR_ANNOUNCEMENT_ALREADY_DECLARED);
        } else if (rollCount == 0) {
            throw new DiceRollRequiredException(MessageConstants.ERROR_DICE_ROLL_REQUIRED);
        } else if (rollCount > 1) {
            throw new AnnouncementUnavailableException(MessageConstants.ERROR_ANNOUNCEMENT_NOT_AVAILABLE);
        }
    }

    private void validateRestartAction() {
        if (status == GameStatus.FINISHED) {
            throw new RestartFinishedGameException(MessageConstants.ERROR_RESTART_FINISHED_GAME);
        }
    }

    
    private Boolean isBoxAvailable(ColumnType cType, BoxType bType) {
        if (gameSheet.columns.get(cType.ordinal()).boxes.get(bType.ordinal()).value != null) {
            return false;
        }   
        if (cType == ColumnType.FREE) {
            return true;
        } else if (cType == ColumnType.DOWNWARDS) {
            return bType == BoxType.ONES || gameSheet.columns.get(cType.ordinal()).boxes.get(bType.ordinal() - 1).value != null;
        } else if (cType == ColumnType.UPWARDS) {
            return bType == BoxType.YAMB || gameSheet.columns.get(cType.ordinal()).boxes.get(bType.ordinal() + 1).value != null;
        } else if (cType == ColumnType.ANNOUNCEMENT) {
            return bType == announcement;
        }
        return false;
    }
}