@isTest
private class GenerateOrderFromDealController_Test{
/**
    *  Description-Test Method to pass the Deal Id to Flow parameter and test different scenario's 
    *  @name-CRM_GenerateOrderFromDealControllerTestDataMethod()
    *  @param-None
    *  @return-None
    *  @throws exception- An unhandled fault has occurred while processing the flow.  Please contact your system administrator for more information.
    */
    static testMethod void CRM_GenerateOrderFromDealControllerTestDataMethod(){
        List<Account> lstSoltToAccounts = new List<Account>();
        List<Opportunity> lstDeals;
        List<Product2> lstProduct2 = new List<Product2>();
        List<PricebookEntry>  lstPricebookEntry = new List<PricebookEntry>();
        List<OpportunityLineItem> lstOpportunityLineItem = new List<OpportunityLineItem>();
        List<OpportunityLineItem> lstUpdatedOpportunityLineItem = new List<OpportunityLineItem>();
        ApexPages.StandardController sc;
        GenerateOrderFromDealController testOrder;
        
        //User u = [Select Id from User where Id =: userInfo.getUserId()];
        //System.runAs(u) {
            //Creating accounts to pass as parameter while creating opportunities
            List<Account> lstAccounts; // = TestDataFactory.createAccounts(1,false);
            
            for (Account acct : lstAccounts)
            {
                //acct.RecordTypeId = CRM_RecordTypeUtil.RT_ACCOUNT_SOLD_TO;
                lstSoltToAccounts.add(acct);
            }
            insert lstSoltToAccounts;
            
            System.assertNotEquals(null, lstSoltToAccounts[0].Id, 'Error while creating Accounts');
            
            //Create Products
            //lstProduct2 = CRM_TestDataFactory.createProducts(CRM_TestDataFactory.createProductGroups(1,true),1,true);
            
            //Create PriceBook Entries
            //lstPricebookEntry =CRM_TestDataFactory.createPriceBookEntries(lstProduct2,1,true);

            // Create Deals to generate Order and Order Products from the deal
            //lstDeals = CRM_TestDataFactory.createOpportunitiesWithAccounts(lstSoltToAccounts,1,true);
            System.assertEquals(1, lstDeals.size(), 'Created Opportunity');
            
            //Create Deal Product
           // lstOpportunityLineItem = CRM_TestDataFactory.createDealProductsWithOpportunities(lstPricebookEntry,lstDeals,1,false);
            for(OpportunityLineItem oli : lstOpportunityLineItem){
                //oli.Initial_Quantity__c =2;
               // oli.Promoted_Price__c =10;
                lstUpdatedOpportunityLineItem.add(oli);
            }
            insert lstUpdatedOpportunityLineItem;
            System.AssertEquals(1,lstUpdatedOpportunityLineItem.size(),'Created Deal Product');
            
            Test.StartTest();

            sc = new ApexPages.StandardController(lstDeals[0]);
            testOrder = new GenerateOrderFromDealController(sc);
            testOrder.startFlow();
            

            PageReference pageRef = Page.GenerateOrderFromDeal;
            Test.setCurrentPage(pageRef);
            
            try{
                sc = new ApexPages.StandardController(lstDeals[0]);
                testOrder = new GenerateOrderFromDealController(sc);
                testOrder.params = null;
                testOrder.startFlow();
                
            }
            catch(Exception e){
                System.AssertEquals(true,e.getMessage().contains(null));
                
            }
            delete lstDeals;   
            Test.StopTest();
        } 
    //}
    
}