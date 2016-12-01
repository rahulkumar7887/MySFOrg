trigger OpportunityTrigger on Opportunity (before insert, after insert, before update, after update, before delete, after delete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
        	OpportunityTriggerHandler.createNewTask(Trigger.New);
    	} 
        if(Trigger.isDelete) { // Trigger.isAfter mein bhi chal raha hai 
            //In delete trigger we don't have access to Trigger.New
            //OpportunityTriggerHandler.preventOpptyDelete(Trigger.New);
            OpportunityTriggerHandler.preventOpptyDelete(Trigger.Old);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate) {
            OpportunityTriggerHandler.createAsset(Trigger.New);
        }
        if(Trigger.isDelete) { // Trigger.isAfter mein bhi chal raha hai 
            //In delete trigger we don't have access to Trigger.New
            //OpportunityTriggerHandler.preventOpptyDelete(Trigger.New);
            OpportunityTriggerHandler.preventOpptyDelete(Trigger.Old);
        }
    }       
}