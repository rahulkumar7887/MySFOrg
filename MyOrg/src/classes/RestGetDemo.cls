@RestResource(urlMapping='/getAccountDemo/*')
global with sharing class RestGetDemo {
    
    @HttpGet
    global static Account getAccountById() {
        RestRequest req = RestContext.request;
        
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Id,Name FROM Account WHERE Id = :accountId];
        return result;
    }
}