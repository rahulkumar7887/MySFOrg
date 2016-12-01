global with sharing class syncAccountCtrl {

    public syncAccountCtrl(ApexPages.StandardController controller) {

    }
	
    @RemoteAction
    global static void syncAccount(Id accId){
        Account acc = [Select Id, Name, (Select Id, FirstName from Contacts) from Account Where Id =: accId];
        List<Contact> lstContact = acc.contacts;
        List<Contact> lstContactsToUpdate = new List<Contact>();
        for(Contact con: lstContact){
            con.FirstName = acc.Name;
            lstContactsToUpdate.add(con);
        }
        
        System.debug('## lstContactsToUpdate' + lstContactsToUpdate);
        if(!lstContactsToUpdate.isEmpty()){
            update lstContactsToUpdate;
        }        
    }
}