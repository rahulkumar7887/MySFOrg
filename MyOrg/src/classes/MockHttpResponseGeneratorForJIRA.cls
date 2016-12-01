// Simulates the HTTP response object for the JIRA callouts
@isTest
global class MockHttpResponseGeneratorForJIRA implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req){
        Map<String, JIRA_Settings__c> settings_map = JIRA_Settings__c.getAll();
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        
        if(!settings_map.containsKey('jiraURL')){
            res.setBody('{"errorMessages": ["jiraURL missing from JIRA_Settings__c"]}');
            return res;
        }
        
        String method = req.getMethod();
        String endpoint = req.getEndpoint(); 
        
        system.assert(endpoint.startsWith(settings_map.get('jiraURL').Value__c));
        
        res.setStatusCode(200);
        res.setStatus('OK');
        
        if(method == 'POST'){ // create issue request
            res.setBody('{"id":"1000", "key":"Test-01", "self":"http://localhost:80"}');
        }
        else if(method == 'PUT'){ // associate issue request
            res.setStatusCode(204);
            res.setStatus('No Content');
        }
        else{ // method == 'GET'
            if(endpoint.contains('labels')){ // get label suggestions request
                res.setBody(getLabelsResponse());
            }
            else if(endpoint.contains('users')){ // get reporter's manager request
                res.setBody(getUsersResponse());
            }
            else{ // issue query request
                res.setBody(getQueryResponse());
            }
        }
        
        return res;
    }
    
    private String getLabelsResponse(){
        String response = '{"suggestions":[';
        response += '{"label":"Test Label", "html":"Test HTML"}';
        response += ']}';
        return response;
    }
    
    private String getUsersResponse(){
        String response = '{"users":[';
        response += '{"name":"Test User", "html":"Test HTML", "displayName":"Test Name"}';
        response += ']}';
        system.debug('users response: ' + response);
        return response;
    }
    
    private String getQueryResponse(){
        String response = '{"issues": [{"key":"Test-01","fields":{';
        response += '"summary":"Test",';
        response += '"priority":{"name":"Medium"},';
        response += '"status":{"name":"New"}';
        response += '}}]}';
        system.debug('query response: ' + response);
        return response;
    }
}