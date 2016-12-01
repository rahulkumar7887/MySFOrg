@isTest(SeeAllData=false)
public class OpportunityLineItemTriggerHelper_Test {
    public static List<Account> lstAccount;
    public static List<Opportunity> lstOpportunity1, lstOpportunity2, lstOpportunity3;
    public static List<Product2> lstProduct1, lstProduct2, lstProduct3;
    //public static List<Product2> lstProduct2;
    //public static List<Product2> lstProduct3;
    
    public static void testData(){
        lstAccount = TestDataFactory.createAccounts(1, true);
    }
    
    public static testMethod void createSchedules_Test1(){
        testData();
        Test.startTest();
        lstOpportunity1 = TestDataFactory.createOpportunitiesWithAccounts(lstAccount, 1, true);
        
        lstProduct1 = TestDataFactory.createProducts(1, false);
        lstProduct1[0].isActive = true;
        lstProduct1[0].CanUseQuantitySchedule = true;
        lstProduct1[0].CanUseRevenueSchedule = true;
        insert lstProduct1;
        
        List<PricebookEntry> lstPriceBookEntry1 = TestDataFactory.createPriceBookEntries(lstProduct1, 1, true);
       
        List<OpportunityLineItem> lstOpportunityLineItem1 = TestDataFactory.createDealProductsWithOpportunities(lstPriceBookEntry1, lstOpportunity1, 1, true);
        System.assertEquals(1, [Select Id From OpportunityLineItemSchedule].size(), 'Both');     
        Test.stopTest();
    }
    
    public static testMethod void createSchedules_Test2(){
        testData();
        Test.startTest();
        
        lstOpportunity2 = TestDataFactory.createOpportunitiesWithAccounts(lstAccount, 1, true);
        
        lstProduct2 = TestDataFactory.createProducts(1, false);
        lstProduct2[0].isActive = true;
        lstProduct2[0].CanUseQuantitySchedule = true;
        lstProduct2[0].CanUseRevenueSchedule = false;
        insert lstProduct2;
        
        List<PricebookEntry> lstPriceBookEntry2 = TestDataFactory.createPriceBookEntries(lstProduct2, 1, true);
        
        List<OpportunityLineItem> lstOpportunityLineItem2 = TestDataFactory.createDealProductsWithOpportunities(lstPriceBookEntry2, lstOpportunity2, 1, true);
        System.assertEquals(1, [Select Id From OpportunityLineItemSchedule].size(), 'Quantity');   
        Test.stopTest();
    }
    
    public static testMethod void createSchedules_Test3(){
        testData();
        Test.startTest();
        lstOpportunity3 = TestDataFactory.createOpportunitiesWithAccounts(lstAccount, 1, true);
        
        lstProduct3 = TestDataFactory.createProducts(1, false);
        lstProduct3[0].isActive = true;
        lstProduct3[0].CanUseQuantitySchedule = false;
        lstProduct3[0].CanUseRevenueSchedule = true;
        insert lstProduct3;
        
        List<PricebookEntry> lstPriceBookEntry3 = TestDataFactory.createPriceBookEntries(lstProduct3, 1, true);
        
        List<OpportunityLineItem> lstOpportunityLineItem3 = TestDataFactory.createDealProductsWithOpportunities(lstPriceBookEntry3, lstOpportunity3, 1, true);
        System.assertEquals(1, [Select Id From OpportunityLineItemSchedule].size(), 'Revenue');     
        Test.stopTest();
    }
}