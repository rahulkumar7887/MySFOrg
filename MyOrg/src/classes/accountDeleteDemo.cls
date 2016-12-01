@RestResource(urlMapping='/accountDeleteDemo/*') 
global with sharing class accountDeleteDemo{
        
    @HttpDelete
    global static Account UpdateAccount() {
        RestRequest req = RestContext.request;
        
        String accId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        Account  accObj = [SELECT Id FROM Account WHERE Id =: accId];
                
        delete accObj;
        return null;
    }
}