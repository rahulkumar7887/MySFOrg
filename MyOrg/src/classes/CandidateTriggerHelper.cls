public with sharing class CandidateTriggerHelper{
    public static void candidateDuplicateCheck(List<Candidate__c> cList){
        List<Candidate__c> lstCandidate = [select First_Name__c,Last_Name__c from Candidate__c];
        system.debug('list of cadidates'+lstCandidate);
        
       
        for(Candidate__c c: cList ){
            for(Candidate__c ce: lstCandidate ){
                if(ce.First_Name__c == c.First_Name__c && ce.Last_Name__c == c.Last_Name__c ){
                     c.First_Name__c.addError('Candidate already exist');
                }
            }
        }
    }
    
    public static void bulkLoadCandidate(List<Candidate__c> cList){
        for(Candidate__c c: cList){
            c.Batch_Load_Item__c = true;
        }
    }
}