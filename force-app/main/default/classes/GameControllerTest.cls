@IsTest
public class GameControllerTest {
    
    private static final List<Integer> DICE_TO_ROLL = new List<Integer>{0, 1, 2, 3, 4};
    
    @TestSetup
    private static void createTestData() {
        Game__c game = new Game__c();
        insert game;        
    }
    
    @IsTest
    public static void testRollDiceByGameId() {
        // ARANGE
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];
        // ACT
        Test.startTest();
        Sheet sheet = GameController.rollDiceBygameId(game.Id, DICE_TO_ROLL);
        Test.stopTest();
        // ASSERT
        Assert.areEqual(1, sheet.rollCount);
    }
    
    @IsTest
    public static void testFillBoxByGameId() {
        // ARANGE
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];
        // ACT
        Test.startTest();
		GameController.rollDiceBygameId(game.Id, DICE_TO_ROLL);
        Sheet sheet = GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.ONES));
        Test.stopTest();
        // ASSERT
        Box box = sheet.columnMap.get(ColumnType.DOWNWARDS).boxMap.get(BoxType.ONES);
        Assert.isTrue(box.filled);
        Assert.isTrue(!box.available);
    }
    
    @IsTest
    public static void testMakeAnnouncementByGameId() {
        // ARANGE
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];
        // ACT
        Test.startTest();
        GameController.rollDiceBygameId(game.Id, DICE_TO_ROLL);
        Sheet sheet = GameController.makeAnnouncementByGameId(game.Id, String.valueOf(BoxType.ONES));
        Test.stopTest();
        // ASSERT
        Assert.areEqual(BoxType.ONES, sheet.announcement);
    }
    
    @IsTest
    public static void testRestartGameById() {
        // ARANGE
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];
        // ACT
        Test.startTest();
        Sheet sheet = GameController.restartByGameId(game.Id);
        Test.stopTest();
        // ASSERT
        Assert.isTrue(sheet.announcement == null);
        Assert.areEqual(0, sheet.rollCount);
    }
    
    @IsTest
    public static void testRollLimitReachedException() {
        // ARANGE
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];
        // Act
        Test.startTest();
        try {
            for (Integer i = 0; i < 4; i++) {
                GameController.rollDiceBygameId(game.Id, DICE_TO_ROLL);
            }
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_ROLL_LIMIT_REACHED, e.getMessage());
        }
        Test.stopTest();
        // Assert
    }
    
    @IsTest
    public static void testAnnouncementRequiredException() {
        // Arange
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];
        // Act
        Test.startTest();
        try {
            for (Integer i = 0; i < BoxType.values().size(); i++) {
                GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);
                GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.values()[i]));
            }
            for (Integer i = BoxType.values().size() - 1; i >= 0; i--) {
                GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);
                GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.UPWARDS), String.valueOf(BoxType.values()[i]));
            }
            for (Integer i = 0; i < BoxType.values().size(); i++) {
                GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);
                GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.FREE), String.valueOf(BoxType.values()[i]));
            } 
            GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);
            GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);
        } catch (AuraHandledException e) {
            Assert.areEqual(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_REQUIRED, e.getMessage());
        }
        Test.stopTest();
        // Assert
    }
    
    @IsTest
    public static void testBoxAlreadyFilledException() {
        // Arange
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];         
        // Act
        Test.startTest();
        try {         
            GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);                        
            GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.ONES));
            GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);  
            GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.ONES));
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_BOX_ALREADY_FILLED, e.getMessage());
        }
        Test.stopTest();
        // Assert
    }
    
    @IsTest
    public static void testBoxNotAvailableException() {
        // Arange
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];   
        Exception caughtException = null;
        // Act
        Test.startTest();
        try {          
            GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);                            
            GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.TWOS));
        } catch (AuraHandledException e) {
        	caughtException = e;
        }
        Test.stopTest();
        // Assert
        Assert.areEqual(GameConstants.ERROR_MESSAGE_BOX_NOT_AVAILABLE, caughtException.getMessage());
    }
    
    @IsTest
    public static void testDiceRollRequiredException() {
        // Arange
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];            
        // Act
        Test.startTest();
        try {          
            GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.ONES));
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_DICE_ROLL_REQUIRED, e.getMessage());
        }
        Test.stopTest();
        // Assert
    }
    
    @IsTest
    public static void testBoxNotAnnouncedException() {
        // Arange
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];            
        // Act
        Test.startTest();
        try {          
            GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);    
            GameController.makeAnnouncementByGameId(game.Id, String.valueOf(BoxType.ONES));
            GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.ANNOUNCEMENT), String.valueOf(BoxType.TWOS));
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_BOX_NOT_ANNOUNCED, e.getMessage());
        }
        Test.stopTest();
        // Assert
    }
    
    @IsTest
    public static void testAnnouncementAlreadyDeclaredException() {
        // Arange
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];            
        // Act
        Test.startTest();
        try {          
            GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);    
            GameController.makeAnnouncementByGameId(game.Id, String.valueOf(BoxType.ONES));
            GameController.makeAnnouncementByGameId(game.Id, String.valueOf(BoxType.TWOS));
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_ALREADY_DECLARED, e.getMessage());
        }
        Test.stopTest();
        // Assert
    }
    
    @IsTest
    public static void testAnnouncementNotAvailableException() {
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];            
        //
        Test.startTest();
        try {
            GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);    
            GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);    
            GameController.makeAnnouncementByGameId(game.Id, String.valueOf(BoxType.ONES));
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_NOT_AVAILABLE, e.getMessage());
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void testRestartFinishedGameException() {
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];
        // fill out the first three columns before Test.startTest() so that the test doesn't hit query and dml limits
        for (Integer i = 0; i < BoxType.values().size(); i++) {
            GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);
            GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.values()[i]));
        }
        for (Integer i = BoxType.values().size() - 1; i >= 0; i--) {
            GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);
            GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.UPWARDS), String.valueOf(BoxType.values()[i]));
        }
        for (Integer i = 0; i < BoxType.values().size(); i++) {
            GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);
            GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.FREE), String.valueOf(BoxType.values()[i]));
        }        
        Test.startTest();
        try {
            for (Integer i = 0; i < BoxType.values().size(); i++) {
                GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);
                GameController.makeAnnouncementByGameId(game.Id, String.valueOf(BoxType.values()[i]));
                GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.ANNOUNCEMENT), String.valueOf(BoxType.values()[i]));
            }
            GameController.restartByGameId(game.Id);
        } catch (AuraHandledException e) {
        	Assert.areEqual(GameConstants.ERROR_MESSAGE_RESTART_COMPLETED_SHEET, e.getMessage());
        }
        Test.stopTest();
    }

}