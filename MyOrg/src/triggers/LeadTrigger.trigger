trigger LeadTrigger on Lead (after insert, after update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            LeadTriggerHandler.convertLead(Trigger.New);
        }
        if(Trigger.isUpdate){
            
        }
    }
}