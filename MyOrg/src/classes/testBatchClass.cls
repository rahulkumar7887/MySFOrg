@isTest(seeAllData=true)
private class testBatchClass {
    static testmethod void test() {
        String query = 'Select Id,AccountId,LastName from Contact';
        Test.startTest();
        contactBatchClass batch = new contactBatchClass(query);
        Database.executeBatch(batch);
        Test.stopTest();        
    }
}