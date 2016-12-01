@RestResource(urlMapping='/v3/AccountAPI/*') 
//Every request that comes to this service will map into this class

global with sharing class RestDemo3 {
    
    @HttpGet
    global static AccountWrapper getAccountById() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        AccountWrapper response = new AccountWrapper();
        
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        List<Account> result = [SELECT Name,Description FROM Account];
        //return result;
        
        if( result != null && result.size() > 0 ) {
            response.acct = result;
            response.status = 'Success';
        }
        else {
            response.acct = result;
            response.status = 'Error';
            response.message = 'This Account cannot be found';
            res.StatusCode = 404;
        }
        return response;
    }
    
    @HttpPost
    global static AccountWrapper createAccount(String name, String description) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        AccountWrapper response = new AccountWrapper();
        
        Account acct = new Account(Name=name, Description=description );
        insert acct;
        
        response.acct.add(acct);
        response.status = 'Success';
        response.message = 'Account created Successfully';
        return response;
    }
    
    global class AccountWrapper {
        public List<Account> acct;
        public String status;
        public String message;
        
        public void AccountWrapper() {
        }        
    }
}