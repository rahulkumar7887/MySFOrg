trigger CandidateTrigger on Candidate__c (before insert, before update, before delete, after insert, after update, after delete) {
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            CandidateTriggerHelper.candidateDuplicateCheck(Trigger.new);
        }
        if(Trigger.isUpdate){
            CandidateTriggerHelper.bulkLoadCandidate(Trigger.new);
        }
        if(Trigger.isDelete){
           
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            
        }
        if(Trigger.isUpdate){
            
        }
        if(Trigger.isDelete){
           
        }
    }
}