public class AccountTriggerHelper {
    
    public static void addAccountTeamMember(List<Account> aList){
        List<AccountTeamMember> lstAccountTeamMember = new List<AccountTeamMember>();
        for(Account a: aList){
            lstAccountTeamMember.add(new AccountTeamMember(AccountId = a.Id, UserId = a.Account_User__c, TeamMemberRole = 'Account Manager'));
        }
        Database.SaveResult[] insertResult = Database.insert(lstAccountTeamMember, false);
        for(Integer i=0; i< insertResult.size(); i++){
      		if(!insertResult[i].isSuccess()) {
                system.debug('insertResult' + insertResult);
            }
        }
    	String strTeamMembersJSON = JSON.serialize(lstAccountTeamMember);
        updateAccountTeamMember(strTeamMembersJSON);
    }
    public static void updateAccountTeamMember(String strTeamMembersJSON){
        AccountTeamMember[] listTeamMembers = (AccountTeamMember[])JSON.deserialize(strTeamMembersJSON, List<AccountTeamMember>.class);
        for(AccountTeamMember teamMember : listTeamMembers) {
        	//normal processings
        }
    }
    
    public static void preventAccountDelete(List<Account> aList){
        String errorMsg = Label.Account_cannot_be_deleted;
        
        Permission__c permission = Permission__c.getInstance();
        Boolean isDeletePermission = (permission != null && (permission.Delete_Permission__c) == True);
        for(Account a: aList){
            if(!isDeletePermission && a.Status__c != 'Can Delete'){
                a.addError(errorMsg);
            }
        }
    }
    
    public static void autoCreateRecordFollower(List<Account> aList){
        List<EntitySubscription> lstEntitySubscription = new List<EntitySubscription>(); 
        Set<Id> accIdSet = new Set<Id>();
        for(Account accList: aList) {
            accIdSet.add(accList.Id);
        }
        List<EntitySubscription> entitySubscription = [Select ParentId from EntitySubscription where ParentId IN :accIdSet];
        Set<Id> entitySubscriptionIdSet = new Set<Id>();
        for(EntitySubscription es: entitySubscription) {
            entitySubscriptionIdSet.add(es.ParentId);
        }
        for(Account a: aList){
            if(!entitySubscriptionIdSet.contains(a.Id) && a.Account_User__c != NULL)
            	lstEntitySubscription.add(new EntitySubscription(ParentId = a.Id, SubscriberId = a.Account_User__c));
        }
        if(!lstEntitySubscription.isEmpty()) {
        	insert lstEntitySubscription;    
        }        
    }
    
    public static void updateOpptyStatus(Map<Id, Account> mapAccount){
        List<Opportunity> lstOpportunityTOUpdate = new List<Opportunity>();
        List<Account> lstAccount = [Select Id, Stage__c, (Select Id, Name, StageName, Status__c From Opportunities) From Account Where Id = :mapAccount.keySet()];
        System.debug('##lstAccount' + lstAccount);
        for(Account a: lstAccount){
            List<Opportunity> oList = a.Opportunities;
            System.debug('##oList' + oList);
            
            if(a.Stage__c == AppConstants.ACCOUNT_STATUS_CANCELLED){
                for(Opportunity opty: oList){
                    opty.Status__c = AppConstants.OPPORTUNITY_STAGE_CANCELLED;
                    lstOpportunityTOUpdate.add(opty);
                }
            }
        }
        System.debug('##lstOpportunityTOUpdate' + lstOpportunityTOUpdate);
        if(!lstOpportunityTOUpdate.isEmpty()){
            update lstOpportunityTOUpdate;
        }
    } 
    
    public static void updateShippingPostalCode(List<Account> lstAccount){
        for(Account a: lstAccount) {
            if(a.Match_Billing_Address__c == True && a.BillingPostalCode != null) {
                a.ShippingPostalCode = a.BillingPostalCode;
                //DML statement cannot operate on trigger.new or trigger.old in Before Trigger
                //insert a;
            }
        }
    }  
    
    public static void addRelatedRecords(Map<Id, Account> mapAccount){
        List<Opportunity> opportunitiesToCreate = new List<Opportunity>();
    	List<Contact> contactsToCreate = new List<Contact>();
        
        // Get the related opportunities for the accounts in this trigger
        Map<Id,Account> acctsWithOpps = new Map<Id,Account>(
            [SELECT Id, (SELECT Id FROM Contacts), (SELECT Id FROM Opportunities) FROM Account WHERE Id IN :mapAccount.keySet()]);
        
        // Add an opportunity for each account if it doesn't already have one.
        // Iterate through each account.
        for(Account a : mapAccount.values()) {
            System.debug('acctsWithOpps.get(a.Id).Opportunities.size()=' + acctsWithOpps.get(a.Id).Opportunities.size());
            // Check if the account already has a related opportunity.
            if (acctsWithOpps.get(a.Id).Opportunities.size() == 0) {
                // If it doesn't, add a default opportunity
                opportunitiesToCreate.add(new Opportunity(Name=a.Name + ' Opportunity',
                                           StageName='Prospecting',
                                           CloseDate=System.today().addMonths(1),
                                           AccountId=a.Id));
            }
            // Check if the account already has a related contact.
            if (acctsWithOpps.get(a.Id).Contacts.size() == 0) {
            	// If it doesn't, add a default contact
            	contactsToCreate.add(new Contact(
            							AccountId = a.Id,
            							LastName = 'Contact of' + a.Name));
            }
        }
    
        if (opportunitiesToCreate.size() > 0) {
            insert opportunitiesToCreate;
        }
        
        if (!contactsToCreate.isEmpty()) {
            Database.insert(contactsToCreate);
        }
    }
}