@isTest(SeeAllData = false)
public class Batch_AccountCleanTest {
    public static void testData(){
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
    }
    public static testMethod void Batch_AccountClean_Test(){
        Batch_AccountClean bc =  new Batch_AccountClean();
        Test.startTest();
        Database.executebatch(bc);
        Test.stopTest();
    }
}