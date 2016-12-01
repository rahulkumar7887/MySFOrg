trigger OrderTrigger on Order (before insert, before update, after insert, after update) {
	if(Trigger.isBefore){
        if(Trigger.isInsert){
        	OrderTriggerHandler.dontClone(Trigger.New);
        }
        if(Trigger.isUpdate){
        
        }
        if(Trigger.isInsert || Trigger.isUpdate){
        
        }
        if(Trigger.isDelete){
        
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
        }
        
        if(Trigger.isUpdate){
        }
        
        if(Trigger.isInsert || Trigger.isUpdate){
        
        }
        if(Trigger.isDelete){
            
        }
    }
}