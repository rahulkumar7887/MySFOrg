trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    //CaseDiscUpdate obj1 = new CaseDiscUpdate();
    //obj1.updateDisc(Trigger.NEW);
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
        	
        }
        if(Trigger.isUpdate){
            //We can not update Account Related records without using update in Before Update, 
            //we can not even update Account Related records in Before Update because we cannot use Udpate in Before Trigger.
            //AccountTriggerHelper.updateOpptyStatus(Trigger.newMap);
        }
        if(Trigger.isInsert || Trigger.isUpdate){
            AccountTriggerHelper.updateShippingPostalCode(Trigger.New);
            AccountTriggerHelper.addAccountTeamMember(Trigger.New);
            AccountTriggerHelper.autoCreateRecordFollower(Trigger.New);
        }
        if(Trigger.isDelete){
            AccountTriggerHelper.preventAccountDelete(Trigger.New);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            AccountTriggerHelper.addRelatedRecords(Trigger.newMap);
        }
        
        if(Trigger.isUpdate){
            AccountTriggerHelper.updateOpptyStatus(Trigger.newMap);
        }
        
        if(Trigger.isInsert || Trigger.isUpdate){
            ////Max. Trigger Depth
            //AccountTriggerHelper.addRelatedRecords(Trigger.newMap);
            //Max. Trigger Depth
            //AccountTriggerHelper.createUpdateContact(Trigger.New);
        }
        if(Trigger.isDelete){
            
        }
    }
}