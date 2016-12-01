global class BatchClassTemplate implements Database.Batchable<SObject>,Database.Stateful {
    //Database.Stateful: Maintain state of variables Eg: PositionBatch 
    //records to be processed
    public Database.QueryLocator start(Database.BatchableContext bc){
        //Total number of records retrieved by SOQL queries = 50,000
        //Total number of records retrieved by Database.getQueryLocator = 10,000
        return Database.getQueryLocator([Select Id from Account]);
    }
    //login that will be applied to each records in the scope
    global void execute(Database.BatchableContext info, List<SObject> scope){
        
    }
    //logic that will run once
    global void finish(Database.BatchableContext bc){
    
    }
}