public with sharing class GameUtil {
    public static boolean isAnnouncementRequired(List<Column__c> columnList) {
        for (Column__c column : columnList) {
            if (column.Type__c != 'Announcement') {
                for (Box__c box : column.Boxes__r) {
                    if (box.Available__c) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    public static String calculateSums(String formString) {
        Form form = (Form) JSON.deserialize(formString, Form.class);
        Map<String, Integer> sums = new Map<String, Integer>();
        Integer numberSum = 0, differenceSum = 0, labelSum = 0, finalSum = 0;
        for (Column column : form.getColumns()) {
            Boolean onesFilled = false, maxFilled = false, minFilled = false;
            Integer onesValue, maxValue, minValue;
            Integer columnNumberSum = 0, columnDifferenceSum = 0, columnLabelSum = 0;
            for (Box box : column.getBoxes()) {
                if (box.getType() == BoxType.ONES || box.getType() == BoxType.TWOS || box.getType() == BoxType.THREES || box.getType() == BoxType.FOURS || box.getType() == BoxType.FIVES || box.getType() == BoxType.SIXES) {
                    columnNumberSum += box.getValue();
                    if (box.getType() == BoxType.ONES) {
                        onesFilled = box.isFilled();
                        onesValue = box.getValue();
                    }
                } else if (box.getType() == BoxType.TRIPS || box.getType() == BoxType.STRAIGHT || box.getType() == BoxType.FULL || box.getType() == BoxType.POKER || box.getType() == BoxType.YAHTZEE) {
                    columnLabelSum += box.getValue();
                } else if (box.getType() == BoxType.MAX) {
                    maxFilled = box.isFilled();
                    maxValue = box.getValue();
                } else if (box.getType() == BoxType.MIN) {
                    minFilled = box.isFilled();
                    minValue = box.getValue();
                }
                if (onesFilled && maxFilled && minFilled) {
                    differenceSum = (maxValue - minValue) * onesValue;
                }
                column.setNumberSum(columnNumberSum);
                column.setDifferenceSum(columnDifferenceSum); 
                column.setLabelSum(columnLabelSum); 
            }
            numberSum += columnNumberSum;
            differenceSum += columnDifferenceSum;
            labelSum += columnLabelSum;
        }
        finalSum = numberSum + differenceSum + labelSum;
        form.setNumberSum(numberSum);
        form.setDifferenceSum(differenceSum);
        form.setLabelSum(labelSum);
        form.setFinalSum(finalSum);

        System.debug(form);

        return JSON.serialize(form);
    }
}
