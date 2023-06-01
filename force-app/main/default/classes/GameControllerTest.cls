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
        // Arrange
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];
        // Act
        Test.startTest();
        Sheet sheet = GameController.rollDiceBygameId(game.Id, DICE_TO_ROLL);
        Test.stopTest();
        // Assert
        Assert.areEqual(1, sheet.rollCount);
    }
    
    @IsTest
    public static void testFillBoxByGameId() {
        // Arrange
        Game__c game = [SELECT Id, Sheet__c FROM Game__c LIMIT 1];
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);
        sheet.rollDice(DICE_TO_ROLL);
		game.Sheet__c = JSON.serialize(sheet);
        update game;
        // Act
        Test.startTest();
        sheet = GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.ONES));
        Test.stopTest();
        // Assert
        Box box = sheet.columnMap.get(ColumnType.DOWNWARDS).boxMap.get(BoxType.ONES);
        Assert.isTrue(box.filled);
        Assert.isTrue(!box.available);
    }
    
    @IsTest
    public static void testMakeAnnouncementByGameId() {
        // Arrange
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];
        // Act
        Test.startTest();
        GameController.rollDiceBygameId(game.Id, DICE_TO_ROLL);
        Sheet sheet = GameController.makeAnnouncementByGameId(game.Id, String.valueOf(BoxType.ONES));
        Test.stopTest();
        // Assert
        Assert.areEqual(BoxType.ONES, sheet.announcement);
    }
    
    @IsTest
    public static void testRestartGameById() {
        // Arrange
        Game__c game = [SELECT Id FROM Game__c LIMIT 1];
        // Act
        Test.startTest();
        Sheet sheet = GameController.restartByGameId(game.Id);
        Test.stopTest();
        // Assert
        Assert.isTrue(sheet.announcement == null);
        Assert.areEqual(0, sheet.rollCount);
    }
    
    @IsTest
    public static void testRollLimitReachedException() {
        // Arrange
        Game__c game = [SELECT Id, Sheet__c FROM Game__c LIMIT 1];
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);
        sheet.rollDice(DICE_TO_ROLL);
        sheet.rollDice(DICE_TO_ROLL);
        sheet.rollDice(DICE_TO_ROLL);
        game.Sheet__c = JSON.serialize(sheet);
        update game;
        AuraHandledException caughtException;
        // Act
        Test.startTest();
        try {
            GameController.rollDiceBygameId(game.Id, DICE_TO_ROLL);
        } catch (AuraHandledException e) {
        	caughtException = e;
        }
        Test.stopTest();
        // Assert
        Assert.areEqual(GameConstants.ERROR_MESSAGE_ROLL_LIMIT_REACHED, caughtException.getMessage());
    }
    
    @IsTest
    public static void testAnnouncementRequiredException() {
        // Arange
        Game__c game = [SELECT Id, Sheet__c FROM Game__c LIMIT 1];
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);
        for (Integer i = 0; i < BoxType.values().size(); i++) {
            sheet.rollDice(DICE_TO_ROLL);
            sheet.fillBox(ColumnType.DOWNWARDS, BoxType.values()[i]);
        }
        for (Integer i = BoxType.values().size() - 1; i >= 0; i--) {
            sheet.rollDice(DICE_TO_ROLL);
            sheet.fillBox(ColumnType.UPWARDS, BoxType.values()[i]);
        }
        for (Integer i = 0; i < BoxType.values().size(); i++) {
            sheet.rollDice(DICE_TO_ROLL);
            sheet.fillBox(ColumnType.FREE, BoxType.values()[i]);
        } 
        sheet.rollDice(DICE_TO_ROLL);
        game.Sheet__c = JSON.serialize(sheet);
        update game;
        AuraHandledException caughtException;
        // Act
        Test.startTest();
        try {
            GameController.rollDiceByGameId(game.Id, DICE_TO_ROLL);
        } catch (AuraHandledException e) {
            caughtException = e;
        }
        Test.stopTest();
        // Assert
        Assert.areEqual(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_REQUIRED, caughtException.getMessage());

    }
    
    @IsTest
    public static void testBoxAlreadyFilledException() {
        // Arange
        Game__c game = [SELECT Id, Sheet__c FROM Game__c LIMIT 1];      
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);
        sheet.rollDice(DICE_TO_ROLL);                        
        sheet.fillBox(ColumnType.DOWNWARDS, BoxType.ONES);
        sheet.rollDice(DICE_TO_ROLL);  
        game.Sheet__c = JSON.serialize(sheet);
        update game;
        AuraHandledException caughtException;
        // Act
        Test.startTest();
        try {           
            GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.ONES));
        } catch (AuraHandledException e) {
        	caughtException = e;
        }
        Test.stopTest();
        // Assert
        Assert.areEqual(GameConstants.ERROR_MESSAGE_BOX_ALREADY_FILLED, caughtException.getMessage());
    }
    
    @IsTest
    public static void testBoxNotAvailableException() {
        // Arange
        Game__c game = [SELECT Id, Sheet__c FROM Game__c LIMIT 1];   
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);
        sheet.rollDice(DICE_TO_ROLL);
        game.Sheet__c = JSON.serialize(sheet);
        update game;
        AuraHandledException caughtException = null;
        // Act
        Test.startTest();
        try {                                    
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
		AuraHandledException caughtException;        
        // Act
        Test.startTest();
        try {          
            GameController.fillBoxByGameId(game.Id, String.valueOf(ColumnType.DOWNWARDS), String.valueOf(BoxType.ONES));
        } catch (AuraHandledException e) {
        	caughtException = e;	
        }
        Test.stopTest();
        // Assert
        Assert.areEqual(GameConstants.ERROR_MESSAGE_DICE_ROLL_REQUIRED, caughtException.getMessage());
    }
    
    @IsTest
    public static void testBoxNotAnnouncedException() {
        // Arange
        Game__c game = [SELECT Id, Sheet__c FROM Game__c LIMIT 1];            
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);
        sheet.rollDice(DICE_TO_ROLL);    
        sheet.makeAnnouncement(BoxType.ONES);
        game.Sheet__c = JSON.serialize(sheet);
        update game;
        // Act
        Test.startTest();
        try {          
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
        Game__c game = [SELECT Id, Sheet__c FROM Game__c LIMIT 1];           
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);
        sheet.rollDice(DICE_TO_ROLL);    
        sheet.makeAnnouncement(BoxType.ONES);
        game.Sheet__c = JSON.serialize(sheet);
        update game;
        AuraHandledException caughtException;
        // Act
        Test.startTest();
        try {          
            GameController.makeAnnouncementByGameId(game.Id, String.valueOf(BoxType.TWOS));
        } catch (AuraHandledException e) {
        	caughtException = e;
        }
        Test.stopTest();
        // Assert
        Assert.areEqual(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_ALREADY_DECLARED, caughtException.getMessage());
    }
    
    @IsTest
    public static void testAnnouncementNotAvailableException() {
        // Arange
        Game__c game = [SELECT Id, Sheet__c FROM Game__c LIMIT 1];         
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);
        sheet.rollDice(DICE_TO_ROLL);    
        sheet.rollDice(DICE_TO_ROLL);    
        game.Sheet__c = JSON.serialize(sheet);
        update game;
        AuraHandledException caughtException;
        // Act
        Test.startTest();
        try {
            GameController.makeAnnouncementByGameId(game.Id, String.valueOf(BoxType.ONES));
        } catch (AuraHandledException e) {
            caughtException = e;
        }
        Test.stopTest();
        // Assert
        Assert.areEqual(GameConstants.ERROR_MESSAGE_ANNOUNCEMENT_NOT_AVAILABLE, caughtException.getMessage());
    }
    
    @IsTest
    public static void testRestartFinishedGameException() {
        // Arange
        Game__c game = [SELECT Id, Sheet__c FROM Game__c LIMIT 1];
        Sheet sheet = GameUtil.getSheetFromString(game.Sheet__c);
        for (Integer i = 0; i < BoxType.values().size(); i++) {
            sheet.rollDice(DICE_TO_ROLL);
            sheet.fillBox(ColumnType.DOWNWARDS, BoxType.values()[i]);
        }
        for (Integer i = BoxType.values().size() - 1; i >= 0; i--) {
            sheet.rollDice(DICE_TO_ROLL);
            sheet.fillBox(ColumnType.UPWARDS, BoxType.values()[i]);
        }
        for (Integer i = 0; i < BoxType.values().size(); i++) {
            sheet.rollDice(DICE_TO_ROLL);
            sheet.fillBox(ColumnType.FREE, BoxType.values()[i]);
        }
        for (Integer i = 0; i < BoxType.values().size(); i++) {
            sheet.rollDice(DICE_TO_ROLL);
            sheet.makeAnnouncement(BoxType.values()[i]);
            sheet.fillBox(ColumnType.ANNOUNCEMENT, BoxType.values()[i]);
        }
        game.Sheet__c = JSON.serialize(sheet);
        update game;
		AuraHandledException caughtException;
        // Act
        Test.startTest();
        try {
            GameController.restartByGameId(game.Id);
        } catch (AuraHandledException e) {
        	caughtException = e;
        }
        Test.stopTest();
        // Assert
        Assert.areEqual(GameConstants.ERROR_MESSAGE_RESTART_COMPLETED_SHEET, caughtException.getMessage());
    }
    
    @IsTest
    public static void testGetSheetFromGameId() {
        // Arange
        Game__c game = [SELECT Id, Sheet__c FROM Game__c LIMIT 1];  
        // Act
        Test.startTest();
        Sheet sheet = GameController.getSheetFromGameId(game.Id, null); // second parameter is ignored
        Test.stopTest();
        // Assert
        Assert.isNotNull(sheet);
    }
    
    @IsTest
    public static void testGetSheetFromGameIdException() {
        // Arange
        AuraHandledException caughtException;
        // Act
        Test.startTest();
        try {
            Sheet sheet = GameController.getSheetFromGameId(null, null); // second parameter is ignored
        } catch (AuraHandledException e) {
            caughtException = e;
        }
        Test.stopTest();
        // Assert
        Assert.isNotNull(caughtException);
    }

}