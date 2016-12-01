@isTest
private class CloneDealToAnotherAccountCtrl_Test{

   /**
    *  Description-Test Method to create test data for different scenario's
    *  @name-CRM_CloneDealCtrl_TestData
    *  @param-None
    *  @return-None
    *  @throws exception- An unhandled fault has occurred while processing the flow.  Please contact your system administrator for more information.
    */
    /*
    static testMethod void CloneDealCtrl_TestData(){
      
            List<Account> lstAccounts = TestDataFactory.createAccounts(1,True);
            for (Account acct : lstAccounts){
                System.assertNotEquals(null, acct.Id, 'Error while creating Accounts');
            }
      
            List<Opportunity> lstDeals = TestDataFactory.createOpportunitiesWithAccounts(lstAccounts, 1,false);
            for (Opportunity deal: lstDeals){
                deal.RecordTypeId = RecordTypeUtil.RT_DEAL_DIGITAL;
            }
            insert lstDeals; 
            System.assertEquals(1, lstDeals.size(), 'Created Opportunities');
     
            List<Product_Group__c> listProductGroups =   TestDataFactory.createProductGroups(1,true);
            System.assertEquals(1, listProductGroups.size(), 'Created ProductGroups');
            
             List<Product2> listProduct =  TestDataFactory.createProducts(listProductGroups,1,true);
             System.assertEquals(1, listProduct.size(), 'Created Products');
             
             List<PricebookEntry> listPriceBookEntries = TestDataFactory.createPriceBookEntries(listProduct,1,true);
             System.assertEquals(1, listPriceBookEntries.size(), 'Created Pricebook Entries');
      
             List<OpportunityLineItem> listDealProductsWithOpportunities = TestDataFactory.createDealProductsWithOpportunities(listPriceBookEntries,lstDeals,1,true);
              System.assertEquals(1, listPriceBookEntries.size(), 'Created Deal Products');                            
    }
    
    static testMethod void DealCopyMethod(){
        CRM_CloneDealCtrl_TestData();
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
        Id copiedDealID = CRM_CloneDealCtrl.cloneDeal(lstOpp[0].id);
        System.assertNotEquals(null, copiedDealID , 'Opportunity Copied Successfully');
        
    }
    
    static testMethod void DealCopyWithDealProductMethod(){
        CRM_CloneDealCtrl_TestData();
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
        List<OpportunityLineItem> lstDealProducts = [SELECT ID FROM OpportunityLineItem WHERE OpportunityId =:lstOpp[0].id];
        List<Id> dealProductsId = new List<Id>();
        for(OpportunityLineItem oppLineItem : lstDealProducts){
            dealProductsId.add(oppLineItem.Id);
        }
        
        CloneDealCtrl.ProductSaveError[] errors = new CloneDealCtrl.ProductSaveError[]{};
        errors = CloneDealCtrl.cloneDealProducts(lstOpp[0].id,dealProductsId);
        System.assertNotEquals(null, errors , 'Opportunity Copied Successfully With Opportunity Product');
    }
    */
}