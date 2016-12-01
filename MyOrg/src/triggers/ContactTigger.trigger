trigger ContactTigger on Contact (before insert, before update, before delete, after insert, after update, after delete) {
    
    if(Trigger.isBefore && Trigger.isInsert) {
        ContactTiggerSequenceController.executeBeforeInsert(Trigger.New);
    }
    
    if(Trigger.isBefore && Trigger.isUpdate) {
        ContactTiggerSequenceController.executeBeforeUpdate(Trigger.new, Trigger.old);
    }
    
    if(Trigger.isBefore && Trigger.isDelete){
        ContactTiggerSequenceController.executeBeforeDelete(Trigger.old);
    }
    if(Trigger.isAfter && Trigger.isInsert) {
        ContactTiggerSequenceController.executeAfterInsert(Trigger.New);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) {
     
    }
    
    if(Trigger.isAfter && Trigger.isDelete) {
    
    }  
}