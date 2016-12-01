global class linkedinIntegrator {
    private static String username;
    private static String password;
    private static String jiraURL;
    private static String jiraCreateURL;
    
    private static HttpRequest req;
    private static HttpResponse res;
    private static Http http;
    
    public static String errorMessage;
    
    // sets up connection values and authentication header
    WebService static void init(){
        Map<String, JIRA_Settings__c> settings_map = JIRA_Settings__c.getAll();
        errorMessage = null;
        if(!settings_map.containsKey('Username')){
            errorMessage = 'JIRA Username missing from JIRA_Settings__c';
            return;
        }
        if(!settings_map.containsKey('Password')){
            errorMessage = 'JIRA Password missing from JIRA_Settings__c';
            return;
        }
        if(!settings_map.containsKey('jiraURL')){
            errorMessage = 'jiraURL missing from JIRA_Settings__c';
            return;
        }
        if(!settings_map.containsKey('jiraCreateURL')){
            errorMessage = 'jiraCreateURL missing from JIRA_Settings__c';
            return;
        }
        
        username = settings_map.get('Username').Value__c;
        password = settings_map.get('Password').Value__c;
        jiraURL = settings_map.get('jiraURL').Value__c;
        jiraCreateURL = settings_map.get('jiraCreateURL').Value__c;
        
        req = new HttpRequest();
        res = new HttpResponse();
        http = new Http();
        
        Blob headerValue = Blob.valueOf(username+':'+password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept', 'application/json');
    }
    
    // Description:
    // Creates a new JIRA Issue in the JIRA database and associates
    // it to the current case
    // 
    // Input: Id of newly created JIRA_Issue__c record that contains
    // all the information for the issue to be created
    // 
    // Returns: No actual return value but will update JIRA__c record on completion with either the key (on success) or an error message (on failure)
    
    @future (callout=true)
    WebService static void createIssue(Id issueID){
        init();
        String endpoint = jiraURL + '/rest/api/2/issue/';
        //String endpoint = jiraURL + '/rest/api/2/issue/?os_username=rahulkumar7887@yahoo.co.in&os_password=Rahul@123';
        //String endpoint = jiraCreateURL;
                
        system.debug('endpoint: ' + endpoint);
        //system.debug('~~~In createIssue, jiraReferenceField='+jiraReferenceField);
        
        JIRA_Issue__c new_issue = [SELECT Description__c, Issue_Type__c, JIRA_Link__c, Priority__c, Project__c, Reporters_Manager__c, Summary__c FROM JIRA_Issue__c WHERE ID =: issueID];
        
        JIRA__c link = [SELECT Id, Name, JIRA_Errors__c, Case__c, Case__r.OwnerId, Case__r.Owner.Name, Case__r.CaseNumber, Case__r.Status FROM JIRA__c WHERE Id =: new_issue.JIRA_Link__c];
            
        //Set Method and Endpoint
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        
        //String caseURL = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + link.Case__c;
        //system.debug('~~~caseURL='+caseURL);

        // create issue body
        String body = '{"fields":{"project":{"key":"' + new_issue.Project__c + '"}';
        
        if(new_issue.issue_type__c != null){
            body += ', "issuetype":"' + new_issue.issue_type__c + '"'; 
        }
        if(new_issue.description__c != null){
            body += ', "description": "' + new_issue.description__c + '"';
        }
        if(new_issue.summary__c != null){
            body += ', "summary": "' + new_issue.summary__c + '"';
        }
        
        body += '}}';
        system.debug('~~~body='+body);
        req.setBody(body);

        res = http.send(req);
        system.debug('Status Code' + res.getStatusCode());
        system.debug('Status' + res.getStatus());
        system.debug('in try Res: ' + res.toString());
        system.debug('res.getBody: ' + res.getBody());
        
        
        Map<String, Object> result_map = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        system.debug('result_map' + (Map<String, Object>)JSON.deserializeUntyped(res.getBody()));
        // if the insert failed, an error is returned 
        if(result_map.containsKey('errors')){
            Map<String, Object> results = (Map<String, Object>)result_map.get('errors');
            errorMessage = '';
            for(String key : results.keySet()){
                errorMessage += key + ': ' + (String)results.get(key) + '\n';
            }
            system.debug('result_map' + result_map);
            system.debug('JIRA returned an error: ' + errorMessage);
            link.JIRA_Errors__c = errorMessage;
        }
        else{
            String key = (String)result_map.get('key');
            link.Name = key;
            link.Summary__c = new_issue.Summary__c;
            link.Ticket_Status__c = 'Open';
        }
   
        update link;
    }
}