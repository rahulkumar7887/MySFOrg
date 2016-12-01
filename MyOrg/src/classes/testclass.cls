@isTest
private class testclass {
    static testMethod void validate() {
       Book__c book = new Book__c(Name = 'Cloud Computing', Price__c = 100);
       System.debug('Price before inserting new book:' + book.Price__c);

       insert book;       
    
       book = [SELECT Price__c FROM Book__c WHERE Id =: book.Id];
       System.debug('Price after trigger fired: ' + book.Price__c);

       System.assertEquals(100, book.Price__c);
    }
}