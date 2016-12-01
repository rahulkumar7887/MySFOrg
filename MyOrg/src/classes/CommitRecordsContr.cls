public with sharing class CommitRecordsContr {

    public List<A__c> commitList {set; get;} 
    
    public CommitRecordsContr() {
        commitList = [select Acc__c,Commit_Date__c,Week__c from A__c where Commit_Date__c = null];
    }

    public void updateRecords() {
        update commitList;        
    }
}