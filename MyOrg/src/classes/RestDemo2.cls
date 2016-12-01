@RestResource(urlMapping='/v2/AccountAPI/*') 
//Every request that comes to this service will map into this class

global with sharing class RestDemo2 {
    
    @HttpGet
    global static AccountWrapper getAccountById() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        AccountWrapper response = new AccountWrapper();
        
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        List<Account> result = [SELECT Name,Description FROM Account WHERE Id = :accountId];
        //return result;
        
        if( result != null && result.size() > 0 ) {
            response.acct = result[0];
            response.status = 'Success';
        }
        else {
            response.acct = result[0];
            response.status = 'Error';
            response.message = 'This Account cannot be found';
            res.StatusCode = 404;
        }
        return response;
    }
    
    @HttpPost
    global static String createAccount(String name, String description) {
        Account accountRecord = new Account(Name=name, Description=description );
        insert accountRecord;
        return accountRecord.Id;
    }
    
    @HttpPatch
    global static AccountWrapper updateAccount(AccountWrapperRequest accWrapReq) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        AccountWrapperRequest request = new AccountWrapperRequest(accWrapReq); 
        AccountWrapper response = new AccountWrapper();
        
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT id,name FROM Account WHERE Id = :accountId];
        //return result;
        
        if( result != null) {
            response.status = 'Success';
            response.message = 'Record Updated';
            res.StatusCode = 200;
        }
        else {
            response.status = 'Error';
            response.message = 'This Account cannot be found';
            res.StatusCode = 404;
        }
        return response;
    }
    
    global class AccountWrapperRequest {
        public String companyId;
        public Integer carrierId;
        public String lineOfCoverage;
        public String insuranceType;
        public String event;
        
        public AccountWrapperRequest(AccountWrapperRequest accWrapReq) {
            this.companyId = companyId;
            this.carrierId = carrierId;
            this.lineOfCoverage = lineOfCoverage;
            this.insuranceType = insuranceType;
            this.event = event;
        }        
    }
    
    global class AccountWrapper {
        public Account acct;
        public String status;
        public String message;
        
        public void AccountWrapper() {
        }        
    }
}