global class Batch_AccountClean implements Database.Batchable<Sobject>, Database.Stateful {
	global Map<Id, String> mapErrors = new Map<Id, String>();
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([Select Id, Name from Account Where Name Like '%test%']);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope){
        System.debug('##scope' + scope);
        List<Account> lstAccount = scope;
        Database.DeleteResult[] deleteResult = Database.delete(lstAccount, false);
        for(Integer i = 0; i < deleteResult.size(); i++){
            if(!deleteResult[i].isSuccess()){
                mapErrors.put(lstAccount[i].Id, deleteResult[i].getErrors()[0].getMessage());
            }
        }
        System.debug('##mapErrors' + mapErrors);
    }
    
    global void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        String[] toadd = new String[]{'rahul.kumar9@cognizant.com'};
        mail.setToAddresses(toadd);
        mail.setSubject('Batch Status');
        mail.setPlainTextBody('Status of the Batch Class: Batch_AccountClean');
        mail.setHtmlBody('' + mapErrors);
        Messaging.sendEmail(new Messaging.singleEmailMessage[]{mail});
	}
}