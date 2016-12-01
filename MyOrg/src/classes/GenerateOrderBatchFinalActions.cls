global without sharing class GenerateOrderBatchFinalActions implements Database.Batchable<Opportunity>, Database.Stateful{
    global Opportunity opty;
    // Key -> Unique Publish Key, Value --> StageName
    global Map<String,String> mapFinalDealsStageChanges;
    global GenerateOrderController.GenerateError [] generateError ;
    
    /*BATCH START METHOD*/
    global Opportunity[] start(Database.BatchableContext BC){ 
        //return [select Id, AccountId, Account.AccountNumber, StageName, UniqueKey__c from Opportunity where UniqueKey__c IN: mapFinalDealsStageChanges.keySet() ];
    	return [select Id, AccountId, StageName, UniqueKey__c from Opportunity where Id = :opty.Id];
    }    
    
    /*BATCH EXECUTE METHOD*/
    global void execute(Database.BatchableContext BC, List<Opportunity> listDealsForStageChange){
        /*
        for(Opportunity deal : listDealsForStageChange) {
            deal.StageName = mapFinalDealsStageChanges.get(deal.UniqueKey__c);
        }
        
        Database.SaveResult[] dealUpdateResults = Database.update(listDealsForStageChange, false);
        
        for(Integer i=0; i< dealUpdateResults.size(); i++) {
            if(!dealUpdateResults[i].isSuccess()) {
                GenerateOrderController.GenerateError err = new GenerateOrderController.GenerateError();
                err.AccountNumber = listDealsForStageChange[i].Account.AccountNumber;
                err.error = dealUpdateResults[i].getErrors().get(0).getMessage();
                
                generateError.add(err);
            }
        }*/
        System.debug('##execute final');
    }
    
    /*BATCH FINISH METHOD*/
    global void finish(Database.BatchableContext BC){
        try {
            GenerateOrderController.updateOpportunity(opty);
        }
        catch(Exception ex) {
            GenerateOrderController.GenerateError err = new GenerateOrderController.GenerateError();
            err.error = ex.getMessage();
            generateError.add(err);
        }
        //GenerateOrderController.sendCompletionEmail(opty, generateError);
    }
}