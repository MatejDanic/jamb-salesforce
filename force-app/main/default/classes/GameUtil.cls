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
}
