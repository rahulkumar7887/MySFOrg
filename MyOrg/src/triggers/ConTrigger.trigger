trigger ConTrigger on Con__c (after insert) {

    //ConTriggerHandler handler = new ConTriggerHandler();
    
    if(Trigger.isAfter && Trigger.isInsert){
        //handler.handleAfterInsertEvent(Trigger.new);
    }
}