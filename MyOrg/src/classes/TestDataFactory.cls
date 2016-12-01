@isTest(SeeAllData=false)
public class TestDataFactory {
        
    private static Id standardPricebookId ;
    static {
        if(standardPricebookId ==  null){
            // Get standard price book ID.
            // This is available irrespective of the state of SeeAllData.
            standardPricebookId = System.Test.getStandardPricebookId(); 
            //standardPricebookId = Test.getStandardPricebookId(); //Both are same
        }
    }
    
    /**
    * createAccounts(Integer, Boolean)
    *
    * This method is called to create accounts for a test class.
    * numAccts = number of account records to be created.
    * shouldInsert = to tell if records need to be inserted or need just instances (True => will insert records in DB).
    */
    public static List<Account> createAccounts(Integer numAccts, Boolean shouldInsert) {
        List<Account> accts = new List<Account>();
        for(Integer accCount = 0; accCount < numAccts; accCount++){
            accts.add(new Account(Name ='TestAccount ' + accCount, Sales_Organization__c = 'India')); //, Price_Book__c = standardPricebookId));
        }
        
        if(accts != null && accts.size() > 0 && shouldInsert){
            insert accts;
        }
        
        System.assertNotEquals(null,accts);
        return accts;
    }
    
    /**
    * createOpportunitiesWithAccounts(List<Account>, Integer, Boolean)
    *
    * This method is called to create opportunities for a test class.
    * accts = list of accounts for which opporunities needs to created
    * numOppsPerAcct = number of opportunity records to be created for each account
    * shouldInsert = to tell if records need to be inserted or need just instances (True => will insert records in DB).
    */
    public static List<Opportunity> createOpportunitiesWithAccounts(List<Account> accts, Integer numOppsPerAcct, Boolean shouldInsert) {
        List<Opportunity> opps = new List<Opportunity>();
        //Id standardPricebookId = System.Test.getStandardPricebookId();        
        for (Integer accCount = 0; accCount < accts.size(); accCount++) {
            for (Integer oppCount = 0; oppCount < numOppsPerAcct; oppCount++) {
                opps.add(new Opportunity(Name = ' Opportunity ' + Math.random() + oppCount,
                                       StageName = AppConstants.OPPORTUNITY_STAGE_Prospecting,
                                       CloseDate = System.today() + 30,
                                       AccountId = accts[accCount].Id,
                                       Pricebook2Id = standardPricebookId,
                                       Start_Date__c = System.today() + 1,
                                       //CurrencyIsoCode = 'USD', // System field enabled when multiple currency is enabled
                                       RecordTypeId = RecordTypeUtil.RT_DEAL_B2B));
            }
        }
        
        if(shouldInsert && opps != null && opps.size() > 0){
            insert opps;
        }
        
        System.assertNotEquals(null,opps);
        return opps;
    }
    
    /**
    * createProducts(Integer, Boolean)
    *
    * This method is called to create products for a test class.
    * numProducts = number of product records to be created 
    * shouldInsert = to tell if records need to be inserted or need just instances (True => will insert records in DB).
    */
    public static List<Product2> createProducts(Integer numProducts, Boolean shouldInsert){

        List<Product2> lstProduct = new List<Product2>();

        if(numProducts == null)
            numProducts = 1;
        
        for (Integer nProductPerLocalDataCount = 0; nProductPerLocalDataCount < numProducts; nProductPerLocalDataCount++){
            Product2 objProduct = new Product2();                
            objProduct.Name = 'PR ' + nProductPerLocalDataCount + Math.random();
            objProduct.IsActive = true;
            objProduct.CanUseQuantitySchedule = true;
            objProduct.CanUseRevenueSchedule = true;
            //objProduct.External_Id__c = string.valueOf(math.random())+ string.ValueOf(nProductPerLocalDataCount);
            lstProduct.add(objProduct);
        }
        
        if (shouldInsert && lstProduct != null && lstProduct.size() > 0){
            insert lstProduct;
        }
        
        System.assertNotEquals(null,lstProduct);
        return lstProduct;
    } 
    
    /**
    * createPriceBookEntries(List<Product2>, Integer, Boolean)
    *
    * This method is called to create products for a test class.
    * lstProduct = list of product2 for which pricebookentries needs to created
    * numProducts = number of pricebookentries records to be created 
    * shouldInsert = to tell if records need to be inserted or need just instances (True => will insert records in DB).
    */
    public static List<PricebookEntry> createPriceBookEntries(List<Product2> lstProduct, Integer numPBEntriesPerProduct, Boolean shouldInsert){
        List<PricebookEntry> lstPricebookEntry = new List<PricebookEntry>();
        //Id standardPricebookId = System.Test.getStandardPricebookId();     
        for(Integer nProductCount = 0; nProductCount < lstProduct.size(); nProductCount++){         
            
            if (numPBEntriesPerProduct == null)
                numPBEntriesPerProduct = 1;
                
            for (Integer oppCount = 0; oppCount < numPBEntriesPerProduct; oppCount++) {
                PricebookEntry objPriceBookEntry = new PricebookEntry();
                objPriceBookEntry.UseStandardPrice = false;
                objPriceBookEntry.UnitPrice = 10.00 * (oppCount + 1);
                //objPriceBookEntry.CurrencyIsoCode = 'USD';
                objPriceBookEntry.Product2Id = lstProduct[nProductCount].Id;                
                objPriceBookEntry.IsActive = true;
                objPriceBookEntry.Pricebook2Id = standardPricebookId;
                lstPricebookEntry.add(objPriceBookEntry);
            }
        }
        
        if (shouldInsert && lstPricebookEntry != null && lstPricebookEntry.size() > 0){
            insert lstPricebookEntry;
        }
        
        System.assertNotEquals(null,lstPricebookEntry);
        return lstPricebookEntry;
    }    
    
    /**
    * createDealProductsWithOpportunities(List<PricebookEntry>, List<Opportunity>, Integer, Boolean)
    *
    * This method is called to create deal products for a test class.
    * lstPriceBookEntry = list of PriceBookEntry for which deal products needs to created
    * lstOpportunity = list of Opportunity for which pricebookentries needs to created
    * numProducts = number of pricebookentries records to be created 
    * shouldInsert = to tell if records need to be inserted or need just instances (True => will insert records in DB).
    */
    public static List<OpportunityLineItem> createDealProductsWithOpportunities(List<PricebookEntry> lstPriceBookEntry, List<Opportunity> lstOpportunity, Integer numOppsPerDealProduct, Boolean shouldInsert){
        List<OpportunityLineItem> lstDealProduct = new List<OpportunityLineItem>();
        ID idPriceBookEntry;
        if (lstPriceBookEntry != null && lstPriceBookEntry.size() > 0){
            for (Integer nDealProdCount = 0; nDealProdCount < lstOpportunity.size(); nDealProdCount ++){
                for(Integer oppCount = 0; oppCount < numOppsPerDealProduct; oppCount++){
                  
                OpportunityLineItem objDealProduct = new OpportunityLineItem();
                objDealProduct.OpportunityId = lstOpportunity[nDealProdCount].Id;

                if (lstPriceBookEntry.size() >= (oppCount + 1))
                    idPriceBookEntry = lstPriceBookEntry[oppCount].Id;
                      
                objDealProduct.PricebookEntryId = idPriceBookEntry;
                objDealProduct.Quantity = 1;
                objDealProduct.UnitPrice = 14.10;
                lstDealProduct.add(objDealProduct);
                }
            }
        }
        
        if (lstDealProduct != null && lstDealProduct.size() > 0 && shouldInsert){
            insert lstDealProduct;
            System.assertNotEquals(null,lstDealProduct);
        }
        
        return lstDealProduct;        
    }
    
    /**
    * createOpportunitySchedule(List<OpportunityLineItem>, Integer, Boolean)
    *
    * This method is called to create OpportunityLineItemSchedule for a test class.
    * dealProducts = list of dealProducts for which OpportunityLineItemSchedule needs to created
    * noOfRecords = number of OpportunityLineItemSchedule records to be created 
    * shouldInsert = to tell if records need to be inserted or need just instances (True => will insert records in DB).
    */
    public static List<OpportunityLineItemSchedule> createOpportunitySchedule(List<OpportunityLineItem> dealProducts, Integer noOfRecords, Boolean shouldInsert){
        List<OpportunityLineItemSchedule> schedules = new List<OpportunityLineItemSchedule>();
        
        for (OpportunityLineItem currentDealProduct : dealProducts) {            
            for (Integer index = 0; index < noOfRecords; index++) {                
                schedules.add(
                    new OpportunityLineItemSchedule(
                        OpportunityLineItemId = currentDealProduct.ID,
                        Quantity = 21 + index,
                        ScheduleDate = System.today(),
                        Type = 'Quantity'
                    )
                );          
            }            
        }
        
        if(shouldInsert){
            insert schedules;
        }
        
        System.assertNotEquals(null,schedules);
        return schedules;
    }
    
    /**
    * createOrders(List<Account>, Integer, Boolean)
    *
    * This method is called to create Orders for a test class.
    * accts = list of Account for which Orders needs to be created
    * noOfRecords = number of Order records to be created 
    * shouldInsert = to tell if records need to be inserted or need just instances (True => will insert records in DB).
    */
     public static List<Order> createOrders(List<Account> accts, Integer noOfRecords, Boolean shouldInsert){
        List<Order> orders = new List<Order>();

        for (Integer accCount = 0; accCount < accts.size(); accCount++) {            
            for (Integer orderCount = 0; orderCount < noOfRecords; orderCount++) {                
                orders.add(
                        new order(
                                Name = ' Order ' + Math.random() + orderCount,
                                Status = 'Open',
                                AccountId = accts[accCount].Id,
                                PriceBook2Id = standardPricebookId,
                                EffectiveDate = System.today(),
                                EndDate = System.today()+30
                                //CurrencyIsoCode = 'USD'                                
                        )
                );
            }
        }
        
        if(shouldInsert){
            insert orders;
        }
        
         System.assertNotEquals(null,orders);
        return orders;
    }
    
    /**
    * createOrderProductsWithOrder(List<PricebookEntry>, List<Order>, Integer, Boolean)
    *
    * This method is called to create deal products for a test class.
    * lstPriceBookEntry = list of PriceBookEntry for which order products needs to created
    * lstOrder = list of Order for which order products needs to created
    * numProducts = number of order products records to be created 
    * shouldInsert = to tell if records need to be inserted or need just instances (True => will insert records in DB).
    */
    public static List<OrderItem> createOrderProductsWithOrder(List<PricebookEntry> lstPriceBookEntry, List<Order> lstOrder,
                                                              Integer numOrderPerOrderProduct, Boolean shouldInsert){
        List<OrderItem> lstOrderProduct = new List<OrderItem>();
        ID idPriceBookEntry;
        if (lstPriceBookEntry != null && lstPriceBookEntry.size() > 0){
            for (Integer nOrderProdCount = 0; nOrderProdCount < lstOrder.size(); nOrderProdCount ++){
                  
                OrderItem objOrderProduct = new OrderItem();
                objOrderProduct.OrderId = lstOrder[nOrderProdCount].Id;
                    
                if (lstPriceBookEntry.size() >= (nOrderProdCount + 1))
                    idPriceBookEntry = lstPriceBookEntry[nOrderProdCount].Id;
                      
                objOrderProduct.PricebookEntryId = idPriceBookEntry;
                objOrderProduct.Quantity = 1;
                objOrderProduct.UnitPrice = 14.10;                
                lstOrderProduct.add(objOrderProduct);
            }
        }
                                                                  
        if (lstOrderProduct != null && lstOrderProduct.size() > 0 && shouldInsert){
            insert lstOrderProduct;
            System.assertNotEquals(null,lstOrderProduct);
        }
        
        return lstOrderProduct;        
    }
    
    /**
    * createTask(List<Opportunity>, Integer, Boolean)
    *
    * This method is called to create deal products for a test class.
    * lstOpportunity = list of PriceBookEntry for which order products needs to created
    * numProducts = number of order products records to be created 
    * shouldInsert = to tell if records need to be inserted or need just instances (True => will insert records in DB).
    */
    public static List<Task> createTask(List<SObject> lstSObject, Integer noOfRecords, Boolean shouldInsert){
        List<Task> lstTask = new List<Task>();
        List<Opportunity> lstOpportunity = lstSObject;
        //List<Opportunity> lstOpportunity1;
        //List<SObject> lstSObject1 = lstOpportunity1;
        for(Opportunity oppty: lstOpportunity){
            for(Integer taskCount = 0; taskCount < noOfRecords; taskCount++){
                Task task = new Task();
                task.Subject = oppty.Name + 'Follow Up Task' + taskCount;
                task.WhatId = oppty.Id;
                lstTask.add(task);
        	}
        }
        
        if (lstTask != null && lstTask.size() > 0 && shouldInsert){
            insert lstTask;
            System.assertNotEquals(null,lstTask);
        }
        
        return lstTask;
    }
}