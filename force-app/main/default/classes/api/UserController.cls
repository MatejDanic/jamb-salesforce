public with sharing class UserController {

    @AuraEnabled(cacheable=true)
    public static String getOnlineUsersJSON() {
        try {
            return UserService.getOnlineUsersJSON();
        } catch (Exception e) {
            throw new AuraHandledException(e.getTypeName() + '\n' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<User> getOnlineUsers() {
        try {
            return UserService.getOnlineUsers();
        } catch (Exception e) {
            throw new AuraHandledException(e.getTypeName() + '\n' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }

}
