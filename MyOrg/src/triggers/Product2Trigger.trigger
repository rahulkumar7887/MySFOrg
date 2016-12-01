trigger Product2Trigger on Product2 (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        Product2TriggerHandler.createSchedules(Trigger.New);
    }
}