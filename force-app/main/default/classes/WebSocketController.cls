public with sharing class WebSocketController {

    @AuraEnabled(cacheable=true)
    public static List<User> getActiveUsers() {
        
        List<User> userList;
        try {
            userList = [
                SELECT 
                    Id, 
                    CreatedDate,
                    Name, 
                    MediumPhotoUrl
                FROM User 
                WHERE IsActive = true
            ];
        } catch(Exception e) {
            System.debug(e.getMessage());
            return null;
        }
        return userList;
    }
}