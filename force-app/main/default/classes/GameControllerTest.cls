@IsTest
public class GameControllerTest {
    
    private static final List<Integer> DICE_TO_ROLL = new List<Integer>{0, 1, 2, 3, 4};
    
    @TestSetup
    private static void createTestData() {
        Game__c gameRecord = new Game__c();
        insert gameRecord;        
    }
    
    @IsTest
    public static void testRollDiceByGameId() {
        Game__c gameRecord = [SELECT Id FROM Game__c LIMIT 1];
        //
        Test.startTest();
        List<Dice> diceList = GameController.rollDiceBygameId(gameRecord.Id, DICE_TO_ROLL);
        Test.stopTest();
        //
        gameRecord = [SELECT Id, Game_String__c FROM Game__c WHERE Id = :gameRecord.Id];
        Game game = GameUtil.getGameFromGameString(gameRecord.Game_String__c);
        Assert.areEqual(1, game.rollCount);
    }
    
    @IsTest
    public static void testFillBoxByGameId() {
        Game__c gameRecord = [SELECT Id FROM Game__c LIMIT 1];
        //
        Test.startTest();
		GameController.rollDiceBygameId(gameRecord.Id, DICE_TO_ROLL);
        Box box = GameController.fillBoxByGameId(gameRecord.Id, 'DOWNWARDS', 'ONES');
        Test.stopTest();
        //
        Assert.isTrue(box.filled);
        Assert.isTrue(!box.available);
    }
    
    @IsTest
    public static void testMakeAnnouncementByGameId() {
        Game__c gameRecord = [SELECT Id FROM Game__c LIMIT 1];
        //
        Test.startTest();
        GameController.rollDiceBygameId(gameRecord.Id, DICE_TO_ROLL);
        BoxType bType = GameController.makeAnnouncementByGameId(gameRecord.Id, 'ONES');
        Test.stopTest();
        //
        gameRecord = [SELECT Id, Game_String__c FROM Game__c WHERE Id = :gameRecord.Id];
        Game game = GameUtil.getGameFromGameString(gameRecord.Game_String__c);
        Assert.areEqual(BoxType.ONES, game.announcement);
    }
    
    @IsTest
    public static void testRestartGameById() {
        Game__c gameRecord = [SELECT Id FROM Game__c LIMIT 1];
        //
        Test.startTest();
        Game game = GameController.restartGameById(gameRecord.Id);
        Test.stopTest();
        //
        Assert.isTrue(game.announcement == null);
        Assert.areEqual(0, game.rollCount);
    }
    
    @IsTest
    public static void testRollLimitReachedException() {
        Game__c gameRecord = [SELECT Id FROM Game__c LIMIT 1];
        //
        Test.startTest();
        try {
            for (Integer i = 0; i < 4; i++) {
                List<Dice> diceList = GameController.rollDiceBygameId(gameRecord.Id, DICE_TO_ROLL);
            }
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_ROLL_LIMIT_REACHED, e.getMessage());
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void testAnnouncementRequiredException() {
        Game__c gameRecord = [SELECT Id FROM Game__c LIMIT 1];
        //
        Test.startTest();
        try {
            for (Integer i = 0; i < BoxType.values().size(); i++) {
                GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);
                GameController.fillBoxByGameId(gameRecord.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.values()[i]));
            }
            for (Integer i = BoxType.values().size() - 1; i >= 0; i--) {
                GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);
                GameController.fillBoxByGameId(gameRecord.Id, String.valueOf(ColumnType.UPWARDS), String.valueOf(BoxType.values()[i]));
            }
            for (Integer i = 0; i < BoxType.values().size(); i++) {
                GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);
                GameController.fillBoxByGameId(gameRecord.Id, String.valueOf(ColumnType.FREE), String.valueOf(BoxType.values()[i]));
            } 
            GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);
            GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);
        } catch (AuraHandledException e) {
            Assert.areEqual(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_REQUIRED, e.getMessage());
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void testBoxAlreadyFilledException() {
        Game__c gameRecord = [SELECT Id FROM Game__c LIMIT 1];         
        //
        Test.startTest();
        try {         
            GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);                        
            GameController.fillBoxByGameId(gameRecord.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.ONES));
            GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);  
            GameController.fillBoxByGameId(gameRecord.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.ONES));
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_BOX_ALREADY_FILLED, e.getMessage());
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void testBoxNotAvailableException() {
        Game__c gameRecord = [SELECT Id FROM Game__c LIMIT 1];            
        //
        Test.startTest();
        try {          
            GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);                            
            GameController.fillBoxByGameId(gameRecord.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.TWOS));
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_BOX_NOT_AVAILABLE, e.getMessage());
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void testDiceRollRequiredException() {
        Game__c gameRecord = [SELECT Id FROM Game__c LIMIT 1];            
        //
        Test.startTest();
        try {          
            GameController.fillBoxByGameId(gameRecord.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.ONES));
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_DICE_ROLL_REQUIRED, e.getMessage());
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void testBoxNotAnnouncedException() {
        Game__c gameRecord = [SELECT Id FROM Game__c LIMIT 1];            
        //
        Test.startTest();
        try {          
            GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);    
            GameController.makeAnnouncementByGameId(gameRecord.Id, String.valueOf(BoxType.ONES));
            GameController.fillBoxByGameId(gameRecord.Id, String.valueOf(ColumnType.ANNOUNCEMENT), String.valueOf(BoxType.TWOS));
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_BOX_NOT_ANNOUNCED, e.getMessage());
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void testAnnouncementAlreadyDeclaredException() {
        Game__c gameRecord = [SELECT Id FROM Game__c LIMIT 1];            
        //
        Test.startTest();
        try {          
            GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);    
            GameController.makeAnnouncementByGameId(gameRecord.Id, String.valueOf(BoxType.ONES));
            GameController.makeAnnouncementByGameId(gameRecord.Id, String.valueOf(BoxType.TWOS));
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_ALREADY_DECLARED, e.getMessage());
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void testAnnouncementNotAvailableException() {
        Game__c gameRecord = [SELECT Id FROM Game__c LIMIT 1];            
        //
        Test.startTest();
        try {
            GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);    
            GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);    
            GameController.makeAnnouncementByGameId(gameRecord.Id, String.valueOf(BoxType.ONES));
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_NOT_AVAILABLE, e.getMessage());
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void testRestartFinishedGameException() {
        Game__c gameRecord = [SELECT Id FROM Game__c LIMIT 1];
        // fill out the first three columns before Test.startTest() so that the test doesn't hit query and dml limits
        for (Integer i = 0; i < BoxType.values().size(); i++) {
            GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);
            GameController.fillBoxByGameId(gameRecord.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.values()[i]));
        }
        for (Integer i = BoxType.values().size() - 1; i >= 0; i--) {
            GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);
            GameController.fillBoxByGameId(gameRecord.Id, String.valueOf(ColumnType.UPWARDS), String.valueOf(BoxType.values()[i]));
        }
        for (Integer i = 0; i < BoxType.values().size(); i++) {
            GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);
            GameController.fillBoxByGameId(gameRecord.Id, String.valueOf(ColumnType.FREE), String.valueOf(BoxType.values()[i]));
        }        
        Test.startTest();
        try {
            for (Integer i = 0; i < BoxType.values().size(); i++) {
                GameController.rollDiceByGameId(gameRecord.Id, DICE_TO_ROLL);
                GameController.makeAnnouncementByGameId(gameRecord.Id, String.valueOf(BoxType.values()[i]));
                GameController.fillBoxByGameId(gameRecord.Id, String.valueOf(ColumnType.ANNOUNCEMENT), String.valueOf(BoxType.values()[i]));
            }
            GameController.restartGameById(gameRecord.Id);
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_RESTART_FINISHED_GAME, e.getMessage());
        }
        Test.stopTest();
    }

}