public with sharing class UserService {

    public static String getActiveUsersJSON() {

        List<User> userList = [
            SELECT 
                Id, 
                CreatedDate,
                Name, 
                MediumPhotoUrl
            FROM User 
            WHERE IsActive = true
        ];

        return JSON.serialize(userList);
    }

    public static List<User> getActiveUsers() {

        List<User> userList = [
            SELECT 
                Id, 
                CreatedDate,
                Name, 
                MediumPhotoUrl
            FROM User 
            WHERE IsActive = true
        ];

        return userList;
    }

    public static User getUser(String userId) {

        User user = [
            SELECT 
                Id, 
                CreatedDate,
                Name, 
                MediumPhotoUrl
            FROM User 
            WHERE Id = :userId
        ];

        return user;
    }
}