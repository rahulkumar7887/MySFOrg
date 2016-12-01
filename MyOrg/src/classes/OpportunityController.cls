public with sharing class OpportunityController {
    public Account account{get;set;}
    
    public OpportunityController(ApexPages.StandardController stdCon) {
        List<Opportunity> lstOpportunity = [SELECT Id, AccountId, Account.Name FROM Opportunity WHERE Id = :stdCon.getId()];
        account = lstOpportunity[0].Account;
        System.debug('##account '+account );
    }

}