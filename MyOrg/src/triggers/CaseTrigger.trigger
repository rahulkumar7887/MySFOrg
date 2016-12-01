trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            CaseTriggerHandler.updateNumberOfCases(Trigger.New);
        }
        if(Trigger.isUpdate){
            //handler.handleBeforeUpdateEvent(Trigger.OldMap, Trigger.NewMap);
        }
        if(Trigger.isDelete){
            CaseTriggerHandler.deleteNumberOfCases(Trigger.Old);
        }
    }
}