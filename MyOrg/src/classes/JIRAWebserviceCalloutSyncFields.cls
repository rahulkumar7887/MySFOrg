global class JIRAWebserviceCalloutSyncFields {
    @future (callout=true)
    WebService static void syncfields(String JIRA_Key) {
        //Modify these variables:
        String username = 'rahulkumar7887@yahoo.co.in';
        String password = 'Rahul@123';
        String jiraURL = 'https://jira.atlassian.com';
           
        //sObject s = [SELECT Subject, Assignee__c, Priority, Requested_By__c FROM Case WHERE JIRA_Key__c = :JIRA_key LIMIT 1];
        sObject s = [SELECT Subject, Assignee__c, Priority, Requested_By__c FROM Case WHERE id= :JIRA_key LIMIT 1];
        
        String c_summary = (String) s.get('Subject');
        String c_assignee = (String) s.get('Assignee__c');
        String c_priority = (String) s.get('Priority');
        String c_requested_by = (String) s.get('Requested_By__c');
 
         String priorityId;
        //Map Salesforce Prority to JIRA Prority
        if (c_priority  == 'Blocker') {                 // Salesforce.com Priority
            priorityId = '1';                           // JIRA Priority ID
        } else if (c_priority  == 'Critical') {
            priorityId = '2';
        } else if (c_priority  == 'Major') {
            priorityId = '3';
        } else if (c_priority == 'Minor') {
            priorityId = '4';
        } else if (c_priority == 'Trivial') {
            priorityId = '5';
        }
          
        //Construct HTTP request and response
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
  
        //Construct Authorization and Content header
        Blob headerValue = Blob.valueOf(username+':'+password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type','application/json');
  
  
        //Construct Endpoint
        String endpoint = jiraURL+'/rest/api/2/issue/'+JIRA_Key;
          
        //Set Method and Endpoint and Body
        req.setMethod('PUT');
        req.setEndpoint(endpoint);
        req.setBody('{ \"fields\":{\"summary\": \"'+c_summary+'\", \"assigne\":{\"name\":\"'+c_assignee+'\"}, \"priority\":{\"id\":\"'+priorityId+'\"}, \"customfield_10400\":{\"value\":\"'+c_requested_by+'\"}}}');
  
        try {
            //Send endpoint to JIRA
            res = http.send(req);
        } catch(System.CalloutException e) {
            System.debug('ERROR:' + e);
            System.debug(res.toString());
        }
    }
}