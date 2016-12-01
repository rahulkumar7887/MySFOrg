// Simulates an error with the HTTP response object for the JIRA callouts
@isTest
global class MockHttpErrorGeneratorForJIRA implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req){
        Map<String, JIRA_Settings__c> settings_map = JIRA_Settings__c.getAll();
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        
        if(!settings_map.containsKey('jiraURL')){
            res.setBody('{"errorMessages": ["jiraURL missing from JIRA_Settings__c"]}');
            return res;
        }
        
        String endpoint = req.getEndpoint(); 
        
        system.assert(endpoint.startsWith(settings_map.get('jiraURL').Value__c));
        
        res.setStatusCode(400);
        res.setStatus('Bad Request');
        
        res.setBody('{"errorMessages": ["An error has occurred"], "errors": {"error":"An error has occurred"}}');
        
        return res;
    }
}