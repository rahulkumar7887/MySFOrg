@RestResource(urlMapping='/AccountAPI/*') //Every request that comes to this service will map into this class
global with sharing class RestDemo1 {
    
    @HttpGet
    global static Account getAccountById() {
        RestRequest req = RestContext.request;
        //RestReponse res = RestContext.response;
        
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Name,Description FROM Account WHERE Id = :accountId];
        return result;
    }
    
    @HttpPost
    global static String createAccount(String name) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        Account acc = new Account();
        acc.Name = name;
        
        insert acc;
        return acc.id;
    }
    
    @HttpPatch
    global static String UpdateAccount(String Id, String name) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //Account iWrapper = new Account ();
        
        String accId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        Account  accObj = [SELECT Id,name FROM Account WHERE Id =: accId];
        accObj.name = name;
        
        Update accObj;
        return accId;
    }
}