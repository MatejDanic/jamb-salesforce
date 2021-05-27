/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 27.5.2021.
 * ____________________________________________________________
 * 
*/

trigger GameTrigger on Game__c (before insert, before delete) {
    if (Trigger.isInsert) {
        GameService.initializeGames(Trigger.new);
    } else if(Trigger.isDelete) {
        GameService.generateScore(Trigger.old);
    }
}