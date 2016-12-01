@RestResource(urlMapping='/getAccountPostDemo/*')
global with sharing class getAccountPostDemo {
    
    @HttpPost
    global static String createAccount(String name) {
        
        Account acc = new Account();
        acc.Name = name;
        
        insert acc;
        return acc.id;
    }
}