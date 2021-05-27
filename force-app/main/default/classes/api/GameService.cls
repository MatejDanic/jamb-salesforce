/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 17.5.2021.
 * @modified 27.5.2021.
 * ____________________________________________________________
 * 
 */

public with sharing class GameService {

    public static String getGame(String gameId) {

        Game__c game = [SELECT 
                            Id, 
                            Announcement__c, 
                            Roll_Count__c, 
                            Dice__c, 
                            Form__c
                        FROM Game__c 
                        WHERE Id = :gameId][0];

        return JSON.serialize(RecordUtil.recordToMap('GAME', game));
    }

    public static String refresh(String gameId) {

        Game__c game = [SELECT 
                            Id, 
                            Announcement__c, 
                            Roll_Count__c, 
                            Dice__c, 
                            Form__c, 
                            Number_Of_Dice__c, 
                            Number_of_Columns__c,
                            Column_Types__c
                        FROM Game__c 
                        WHERE Id = :gameId][0];
        
        game = initializeGame(game);
        update game;
        
        return JSON.serialize(RecordUtil.recordToMap('GAME', game));
    }
    
    public static void initializeGames(List<Game__c> gameList) {
        for (Game__c game : gameList) {
            game = initializeGame(game);
        }
    }

    public static Game__c initializeGame(Game__c game) {

        List<Dice> diceList = new List<Dice>();
        for (Integer i = 1; i <= Integer.valueOf(game.Number_of_Dice__c); i++) {
            Dice dice = new Dice(i);
            diceList.add(dice);
        }
        game.Dice__c = JSON.serialize(diceList);

        List<Column> columnList = new List<Column>();
        for (Integer i = 1; i <= Integer.valueOf(game.Number_of_Columns__c); i++) {
            ColumnType cType = game.Column_Types__c == 'Classic' ? columnType.values()[i - 1] : ColumnType.ANYDIRECTION;
            List<Box> boxList = new List<Box>();
            for (BoxType bType : BoxType.values()) {
                Boolean available = (cType == ColumnType.DOWNWARDS && bType == BoxType.ONES
                || cType == ColumnType.UPWARDS && bType == BoxType.YAHTZEE
                || cType == ColumnType.ANYDIRECTION
                || cType == ColumnType.ANNOUNCEMENT);
                Box box = new Box(bType, available);
                boxList.add(box);
            }
            Column column = new Column(cType, boxList);
            columnList.add(column);
        }
        Form form = new Form(columnList);
        game.Form__c =  JSON.serialize(form);

        return game;
    }
    
    public static void generateScore(List<Game__c> gameList) {
        List<Score__c> scoreList = new List<Score__c>();
        for (Game__c game : gameList) {
            if (game.Finished__c) {
                Score__c score = new Score__c(Value__c = game.Final_Sum__c, Date__c = DateTime.now());
                scoreList.add(new Score__c(Value__c = game.Final_Sum__c, Date__c = DateTime.now()));
            }
        }
        insert scoreList;
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

    public static String announce(String gameId, String boxTypeString) {
        List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c
                                FROM Game__c WHERE Id = :gameId];
        if (gameList.size() != 1) return null;
        Game__c game = gameList[0];

        if (game.Announcement__c != null) {
            throw new IllegalMoveException('Announcement already declared!');
        } else if (game.Roll_Count__c != 1) {
            throw new IllegalMoveException('Announcement is available only after first roll!');
        }

        game.Announcement__c = boxTypeString;
        update game;

        return game.Announcement__c;
    }

    public static String fill(String gameId, String columnTypeString, String boxTypeString) {
        List<Game__c> gameList = [SELECT Id, Announcement__c, Roll_Count__c, Form__c, Dice__c
                                FROM Game__c WHERE Id = :gameId];
        if (gameList.size() != 1) return null;
        Game__c game = gameList[0];

        Form form = (Form)JSON.deserialize(game.Form__c, Form.class);
        List<Dice> diceList = (List<Dice>)JSON.deserialize(game.Dice__c, List<Dice>.class);

        Box b = form.getColumnByType(columnTypeString).getBoxByType(boxTypeString);
        
        if (b.isFilled()) {
			throw new IllegalMoveException('Box is already filled!');
        } else if (!b.isAvailable()) {
            throw new IllegalMoveException('Box is not available!');
        } else if (game.Roll_Count__c == 0) {
            throw new IllegalMoveException('Cannot fill box without rolling dice first!');
        } else if (game.Announcement__c != null && game.Announcement__c != b.getType().name()) {
            throw new IllegalMoveException('Another box is announced');
        }

        for (Column column : form.getColumns()) {
            if (column.getType().name() == columnTypeString) {
                for (Box box : column.getBoxes()) {
                    if (box.getType().name() == boxTypeString) {
                        box.fill(ScoreUtil.calculateScore(diceList, box.getType()));
                    } else if (column.getType() == ColumnType.DOWNWARDS && 
                    boxTypeString != String.valueOf(BoxType.YAHTZEE) && 
                    ((BoxType)EnumUtil.parseEnum(boxTypeString, BoxType.class)).ordinal() + 1 == box.getType().ordinal()) {
                        box.setAvailable(true);
                    } else if (column.getType() == ColumnType.UPWARDS && 
                    boxTypeString != String.valueOf(BoxType.Ones) && 
                    ((BoxType)EnumUtil.parseEnum(boxTypeString, BoxType.class)).ordinal() - 1 == box.getType().ordinal()) {
                        box.setAvailable(true);
                    }
                }   
                break;
            }
        }
        form.updateSums();
        
        for (Dice dice : diceList) {
            dice.setHeld(false);
        }
        game.Final_Sum__c = form.getFinalSum();
        game.Dice__c = JSON.serialize(diceList);
        game.Form__c = JSON.serialize(form);
        game.Roll_Count__c = 0;
        game.Announcement__c = null;


        update game;

        return JSON.serialize(RecordUtil.recordToMap('GAME', game));
    }
}
