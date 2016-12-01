trigger PositionTrigger on Position__c (before update,after insert,after update) {
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            PositionHelper.checkCompensation(Trigger.new,Trigger.oldMap);
            PositionHelper.approverSetting(Trigger.New);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            PositionHelper.createAutomatedChatter(Trigger.New);
        }
        if(Trigger.isInsert || Trigger.isUpdate){
            PositionHelper.shareRecord(Trigger.new);
            PositionHelper.sendChatterNote(Trigger.New);
        }
    }
}