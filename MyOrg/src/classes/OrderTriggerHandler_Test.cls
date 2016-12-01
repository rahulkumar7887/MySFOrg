@isTest(SeeAllData=false)
private class OrderTriggerHandler_Test{
    public static List<Order> lstOrder;
    /*
    static testmethod void createTestData() {
        List<Account> lstAccounts = CRM_TestDataFactory.createAccounts(2, false);   
        Id tempRecordType = [select id,Name from RecordType where SobjectType='Account' and Name='Sold To' Limit 1].ID;
        lstAccounts[0].RecordTypeID = tempRecordType;
        lstAccounts[0].Planning_Customer__c = True;
        lstAccounts[0].Status__c = 'N';
        lstAccounts[1].RecordTypeID = tempRecordType;
        lstAccounts[1].Planning_Customer__c = True;
        lstAccounts[1].Status__c = 'N';
        upsert lstAccounts;     
        
        List<Product_Group__c> lstProductGroup = CRM_TestDataFactory.createProductGroups(1, true);
        List<Product2> lstProduct = CRM_TestDataFactory.createProducts(lstProductGroup, 200, false); 
        for (Product2 prodInstance : lstProduct) {
            prodInstance.RecordTypeId = CRM_RecordTypeUtil.RT_PRODUCT_PHYSICAL;
        }
        insert lstProduct;
        List<PricebookEntry> lstPriceBookEntries = CRM_TestDataFactory.createPriceBookEntries(lstProduct, 1, true);
        List<Pricebook_Entry_Period__c> lstPriceBookEntryPeriiod = new List<Pricebook_Entry_Period__c>();
        for(Pricebook_Entry_Period__c pbep : CRM_TestDataFactory.createPriceBookEntryPeriods(lstProduct, 1, false)){
            pbep.Start_Date__c = System.today()+1;
            lstPriceBookEntryPeriiod.add(pbep);
        }
        insert lstPriceBookEntryPeriiod;
        System.debug('lstPriceBookEntryPeriiod::'+lstPriceBookEntryPeriiod);
        lstOrder = CRM_TestDataFactory.createOrders(lstAccounts, 2,true);        
        List<OrderItem> lstOrderProduct = CRM_TestDataFactory.createOrderProductWithOrder(lstPriceBookEntries, lstOrder, 1, true);
    }
    */
    
    static testmethod void dontClone_test(){
        //createTestData();
        Test.StartTest();
        
        Test.StopTest();
    }
    static testmethod void generateAttachPDF_test() {
        //createTestData();
        Test.StartTest();
        
        //lstOrder[0].Status = 'Submitted';
        //lstOrder[0].Confirm__c = true;
        //lstOrder[0].Confirmation_Email__c = 'TestEmail@Test.com';
        //upsert lstOrder;
        
        Test.StopTest();
        
        //List<Attachment> attachments=[select id, name from Attachment where parent.id=:lstOrder[0].id];
        //System.assertEquals(1, attachments.size());
    }    
}