@isTest
public class BatchTest {
    @isTest
    public static void bTest(){
        BatchClassTemplate bc =  new BatchClassTemplate();
        String testQuery = 'Select Id from Account';
        Test.startTest();
        Id jobId = Database.executebatch(bc);
        Test.stopTest();
    }
}