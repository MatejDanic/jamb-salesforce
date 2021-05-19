/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 19.5.2021.
 * ____________________________________________________________
 * 
*/

trigger GameTrigger on Game__c (before insert, before delete) {
    if (Trigger.isInsert) {
        GameTriggerHandler.initializeGame(Trigger.new);
    } else if(Trigger.isDelete) {
        GameTriggerHandler.generateScore(Trigger.old);
    } /*else if(Trigger.isUpdate) {
        GameTriggerHandler.handleUpdate(Trigger.oldMap, Trigger.newMap);
    }*/
}