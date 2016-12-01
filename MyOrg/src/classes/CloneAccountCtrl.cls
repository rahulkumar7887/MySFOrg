public with sharing class CloneAccountCtrl{
      
    public static String accountId;
     
    public CloneAccountCtrl(ApexPages.Standardcontroller stdCon) {
        accountId = stdCon.getId();
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
    }
    
    @RemoteAction
    public static void cloneAccount(Id accId){
        System.debug('##accId' + accId);
        List<Account> lstAccount = [Select Id, Name from Account where Id = :accId];
        List<Account> lstAccountToCreate = new List<Account>();
        for(Account acc: lstAccount) {
            lstAccountToCreate.add(new Account(Name = acc.Name));
        }
        
        if(!lstAccountToCreate.isEmpty()){
            insert lstAccountToCreate;
        }

        //PageReference pageRef = new PageReference('/'+lstAccountToCreate[0].Id+'/e?retURL=%2F'+lstAccountToCreate[0].Id);
        //pageRef.setRedirect(true);
        //return pageRef;
    }     
}