@RestResource(urlMapping='/AccountAPITest/*')
global with sharing class UpdateIMStage {

    @HttpPatch
    global static ResponseAccountWrapper doPatch(List<RequestAccountWrapper > impWrapperList) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        RequestAccountWrapper iWrapper = new RequestAccountWrapper(impWrapperList);
        ResponseAccountWrapper resImpWrapper = new ResponseAccountWrapper(); 
        
        String iId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        Account impObj = [SELECT Id,name,Stage__c FROM Account WHERE Id =: iId];
        
        if(impObj != null) {
            resImpWrapper.name = iWrapper.name;
            resImpWrapper.stage= iWrapper.stage;
            resImpWrapper.status = 'Success';
            resImpWrapper .message = 'Record Updated Succesfully';
            res.StatusCode = 200;
        }
        else {
            resImpWrapper.status = 'Error';
            resImpWrapper.message = 'Record cannot be found';
            res.statusCode = 404;
        }
        return resImpWrapper;
    }
    
    global class RequestAccountWrapper {
        public String name;
        public String stage;
        
        public RequestAccountWrapper(List<RequestAccountWrapper> impWrapperList) {
            this.name = name;
            this.stage = stage;
        }    
    }
    global class ResponseAccountWrapper {
        public String name;
        public String stage;
        public String status;
        public String message;
        
        public ResponseAccountWrapper() {
        }    
    }
}