global class BatchClassWithWrapper implements Database.Batchable<SObject> {
    public Account[] start(Database.BatchableContext bc){
        List<Account> lstAccount;
        for(Account a: [select Id from Account limit 10]) {
            lstAccount.add(a);
        }
        return lstAccount;
    }
    global void execute(Database.BatchableContext info, List<Account> scope){
        
    }
    global void finish(Database.BatchableContext bc){
    
    }
    
}