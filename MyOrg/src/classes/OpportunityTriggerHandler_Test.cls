@isTest(SeeAllData=false)
public class OpportunityTriggerHandler_Test {
    public static List<Account> lstAccount;
    public static List<Opportunity> lstOpportunity;
    public static void testData(){
        lstAccount = TestDataFactory.createAccounts(1, true);
        
		lstOpportunity = TestDataFactory.createOpportunitiesWithAccounts(lstAccount, 1, false);        
        
    }
    
    public static testMethod void createAsset_Test(){
        
    }
    
    public static testMethod void preventOpptyDelete_Test(){
        testData();
        lstOpportunity[0].StageName = 'Closed Won';
        update lstOpportunity;
        
        delete lstOpportunity;
        System.assertNotEquals(0, [Select Id From Opportunity].Size() , 'Oppotunity Not Deleted');
    }
    
    public static testMethod void createNewTask_Test(){
        testData();
        lstOpportunity[0].StageName = 'Closed Won';
        insert lstOpportunity;
        System.assertEquals(1, [Select Id From Task Where WhatId = :lstOpportunity[0].Id].size(), 'Task Created');
    }
}