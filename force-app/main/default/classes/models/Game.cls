public class Game {
    
    public Map<Integer, Dice> diceMap { get; private set; }
    public BoxType announcement { get; set; }

    public Game(Form form, Map<Integer, Dice> diceMap) {
        this.form = form;
        this.diceMap = diceMap;
        rollCount = 0;
        announcement = null;
    }

    @AuraEnabled
    public Form form { get; private set; }

    @AuraEnabled
    public transient List<Dice> diceList {
        get {
            List<Dice> diceList = diceMap.values();
            diceList.sort();
            return diceList;
        }
        private set;
    }

    private transient List<Dice> diceListUnsorted {
        get {
            return diceMap.values();
        }
        set;
    }

    @AuraEnabled 
    public Integer rollCount { get; set; }

    @AuraEnabled
    public transient String announcementString { 
        get {
            return announcement == null ? null : String.valueOf(announcement);
        } 
        private set;
    }
    
    @AuraEnabled
    public transient Boolean announcementRequired {
        get {
            for (Column column : form.columnList) {
                if (column.type != ColumnType.ANNOUNCEMENT && column.numOfAvailableBoxes > 0) {
                    return false;
                }
            }
            return true;
        }
        private set;
    }

    @AuraEnabled
    public transient Boolean completed { 
        get {
            return form.numOfAvailableBoxes == 0;
        }
        private set;
    }

    public void rollDice(List<Integer> diceToRoll) {
        // always roll all dice for first roll
        if (rollCount == 0) {
            for (Dice dice : diceListUnsorted) {
                dice.roll();
            }
        } else { // 
            for (Integer diceKey : diceToRoll) {
                Dice dice = diceMap.get(diceKey);
                dice.roll();
            }
        }
        rollCount += 1;
    }   

    public void fillBox(ColumnType cType, BoxType bType) {
        Box selectedBox = form.columnMap.get(cType).boxMap.get(bType);

        selectedBox.fill(ScoreUtil.calculateScore(diceListUnsorted, bType));
        BoxType nextBoxType = selectedBox.getNextBoxType(cType);
        if (nextBoxType != null) {
            Box nextBox = form.columnMap.get(cType).boxMap.get(nextBoxType);
            nextBox.available = true;
        }

        rollCount = 0;
        announcement = null;

        // if (form.isFinished()) {
        //     Score__c score = new Score__c(Value__c = form.totalSum);
        //     insert score;
        // }
    }

}