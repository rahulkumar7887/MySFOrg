trigger campaignTrigger on Campaign (before insert, before update, before delete, after insert, after update, after delete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            
        }
        if(Trigger.isInsert || Trigger.isUpdate){
            
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            //CampaignTriggerHandler.createCampaignMembers(Trigger.New);
            CampaignTriggerHandler.createCampaignMemberStatus(Trigger.New);
            //CampaignTriggerHandler.changeLabel(Trigger.New);            
        }
    }
}