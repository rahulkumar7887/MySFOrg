trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert, after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        OpportunityLineItemTriggerHelper.createSchedules(Trigger.New);
    }
}