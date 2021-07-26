public with sharing class UserController {

    @AuraEnabled(cacheable=true)
    public static String getActiveUsersJSON() {
        try {
            return UserService.getActiveUsersJSON();
        } catch (Exception e) {
            throw new AuraHandledException(e.getTypeName() + '\n' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<User> getActiveUsers() {
        try {
            return UserService.getActiveUsers();
        } catch (Exception e) {
            throw new AuraHandledException(e.getTypeName() + '\n' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }

}
