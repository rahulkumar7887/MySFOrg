@isTest
public class AccountTriggerHelper_Test {
    
    public static List<Account> lstAccount;
    public static void testData(){
        //Create Account
        lstAccount = TestDataFactory.createAccounts(10,false);
    }
    
    public static testMethod void accountAddressValidator_Test(){
        testData();
        Test.StartTest();
        
        lstAccount[0].Match_Billing_Address__c = True;
        lstAccount[0].BillingPostalCode = '1007';
        insert lstAccount;
        System.assertEquals(lstAccount[0].ShippingPostalCode , lstAccount[0].BillingPostalCode , 'BillingPostalCode and ShippingPostalCode  should be same');
        
        Test.StopTest();
        
    }
    
    public static testMethod void updateOpptyStatus_Test(){
        testData();
        Test.StartTest();
        lstAccount[0].Stage__c = 'Cancelled';
        insert lstAccount;
        List<Opportunity> lstOpportunity = [Select Id, Status__c From Opportunity where AccountId =: lstAccount[0].Id];
        System.assertEquals('Cancelled', lstOpportunity[0].Status__c, 'Status should be same');
        
        Test.StopTest();
    }
}