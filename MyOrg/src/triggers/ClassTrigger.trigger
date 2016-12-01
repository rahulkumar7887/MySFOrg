trigger ClassTrigger on Class__c (before delete) {
    ClassHandler ch = new ClassHandler();
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            ch.preventClassDeletion(trigger.old);
        }
    }
}