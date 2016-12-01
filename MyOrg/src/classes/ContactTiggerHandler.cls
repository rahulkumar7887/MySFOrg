public class ContactTiggerHandler {
    
    public static void updateAccountsRelatedContacts(List<Contact> cList) {
        Set<Id> accId = new Set<Id>();
        for(Contact c: cList) {
            accId.add(c.AccountId);
        }
        if(!accId.isEmpty()){
            Map<Id,Account> accMap = new Map<Id,Account>([Select Id,RelatedContacts__c from Account where Id IN: accId]);
            if(!accMap.isEmpty()){
                for(Contact c: cList) {
                    Account acc = accMap.get(c.AccountId);
                    if(acc.RelatedContacts__c == null)
                        acc.RelatedContacts__c = c.LastName;
                    else {    
                        if(!acc.RelatedContacts__c.contains(c.LastName))
                            acc.RelatedContacts__c = acc.RelatedContacts__c + ',' + c.LastName; 
                        //If we remove the first contact then its not removed because it dosent find ',' in starting. 
                        //If we delete contact that is not present in list then it adds the contact in the list, not possible in valid data.
                        else if(acc.RelatedContacts__c.contains(c.LastName)) {
                			acc.RelatedContacts__c = acc.RelatedContacts__c.remove(',' + c.LastName);
                            //acc.RelatedContacts__c = acc.RelatedContacts__c.remove(','); //it removes all the ','
            			}
                    }
                }
                // Insert, Update and Delete    
                update accMap.values();
            }
        }
    }
    
    public static void updateNumberOfContacts(List<Contact> cList){
        Set<Id> accId = new Set<Id>();
        for(Contact c: cList) {
            accId.add(c.AccountId);
        }
        Map<Id,Account> accMap = new Map<Id,Account>([Select Id,Number_of_Contacts__c from Account where Id IN: accId]);
        for(Contact c: cList) {
            Account acc = accMap.get(c.AccountId);
            if(acc != null){
                acc.Number_of_Contacts__c = acc.Number_of_Contacts__c + 1;    
            }
        }
        update accMap.values();    
    }
    public static void removeNumberOfContacts(List<Contact> cList){
        Set<Id> accId = new Set<Id>();
        for(Contact c: cList) {
            accId.add(c.AccountId);
        }
        Map<Id,Account> accMap = new Map<Id,Account>([Select Id,Number_of_Contacts__c from Account where Id IN: accId]);
        for(Contact c: cList) {
            Account acc = accMap.get(c.AccountId);
            if(acc != null){
                acc.Number_of_Contacts__c = acc.Number_of_Contacts__c - 1;    
            }
        }
        update accMap.values();    
    }
    
    public static void changeLastModifiedDate(Map<Id, Contact> cNewMap, Map<Id, Contact> cOldMap){
        for(Id c: cNewMap.Keyset()) {
            //Null Check
            if(cNewMap.get(c).LastModifiedDate != Null && cNewMap.get(c).Account.LastModifiedDate != Null){
                if(cNewMap.get(c).LastModifiedDate != cOldMap.get(c).LastModifiedDate){
                	cNewMap.get(c).Account.LastModifiedDate = cNewMap.get(c).LastModifiedDate;
                }
            }
        }
    }
    /*
    public static void createAccount(List<Contact> lstContact){
        List<Account> accountsToCreate = new List<Account>();
        Account acc;
        Map<String, Contact> mapContactRecords = new Map<String, Contact>();
        for(Contact con: lstContact){
            acc = new Account();
            acc.Name = 'ConCreAcc' + con.LastName;
			acc.UniqueKey__c = con.Id;
            mapContactRecords.put(con.Id, Con);
            accountsToCreate.add(acc);
        }
        if(!accountsToCreate.isEmpty()){
            insert accountsToCreate;
        }
        //Associate Contacts to the Account;
        for(Account a: accountsToCreate){
            if(mapContactRecords.containsKey(a.UniqueKey__c)){
                mapContactRecords.get(a.UniqueKey__c).AccountId = a.Id;
            }
        }
        
        update mapContactRecords.values();
    }*/
}