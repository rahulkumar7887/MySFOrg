@RestResource(urlMapping='/accountPatchDemo/*') 
global with sharing class accountPatchDemo{
        
    @HttpPatch
    global static String UpdateAccount(String Id, String name) {
        RestRequest req = RestContext.request;
        
        String accId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        Account  accObj = [SELECT Id,name FROM Account WHERE Id =: accId];
        accObj.name = name;
        
        Update accObj;
        return accId;
    }
}