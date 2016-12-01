public class JIRALinkTriggerHandler {
    private static String username;
    private static String password;
    private static String jiraURL;
    private static String jiraReferenceField;
    
    private static HttpRequest req;
    private static HttpResponse res;
    private static Http http;
    
    public static String errorMessage;
    
    // sets up connection values and authentication header
    public static void init(){
        system.debug('~~~In init of JIRALinkTriggerHandler');
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
        if(!settings_map.containsKey('jiraReferenceField')){
            errorMessage = 'jiraReferenceField missing from JIRA_Settings__c';
            return;
        }
        
        username = settings_map.get('Username').Value__c;
        password = settings_map.get('Password').Value__c;
        jiraURL = settings_map.get('jiraURL').Value__c;
        jiraReferenceField = settings_map.get('jiraReferenceField').Value__c;
        
        req = new HttpRequest();
        res = new HttpResponse();
        http = new Http();
        
        Blob headerValue = Blob.valueOf(username+':'+password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type','application/json');
        system.debug('~~~req='+req);
    }
    
    //Update JIRA ID Reference based on the SFDC JIRA Link ID 
    //JIRAId: The 18 digit JIRA Link ID in Salesforce
    //JIRAName: The JIRA Link Name for the JIRA Link in Salesforce 
    @future(callout=true)
    public static void updateJIRAReference(String JIRAId, String JIRAName){
        system.debug('~~~JIRAId='+JIRAId+', JIRAName='+JIRAName);
        init();
        String endpoint = jiraURL + '/rest/api/2/issue/' + JIRAName;
        system.debug('~~~endpoint='+endpoint);
        system.debug('~~~jiraReferenceField='+jiraReferenceField);
        
        JIRA__c jiraLink = [SELECT Id, Name, JIRA_Errors__c FROM JIRA__c WHERE Id =: JIRAId limit 1];
        
        //Get old JIRA Reference
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        
        String oldJiraRerefence = '';
        
        try{
            res = http.send(req);
            system.debug('~~~res='+res.toString());
        }catch(Exception e){
            system.debug('~~~Callout Exception: ' + e);
            system.debug('~~~Req: ' + req);
            system.debug('~~~Res: ' + res.toString());
            jiraLink.JIRA_Errors__c = 'Callout Exception for GET: ' + e;
            update jiraLink;
        }        
        
        try{
            Map<String, Object> theMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            Map<String, Object> fieldsMap = (Map<String, Object>)theMap.get('fields');
            system.debug('~~~fieldsMap='+fieldsMap);
            for(String s: fieldsMap.keySet()){
                if(s==jiraReferenceField){
                    system.debug('~~~found jiraReferenceField, s='+jiraReferenceField);
                    oldJiraRerefence = (String)fieldsMap.get(s);
                    system.debug('~~~oldJiraRerefence='+oldJiraRerefence);
                }
            } 
        }
        catch(Exception e){
            system.debug('~~~Problem parsing returned JSON for GET: ' + res.getBody());
            system.debug('~~~Exception caught: ' + e);
            jiraLink.JIRA_Errors__c = 'Problem parsing returned JSON for GET:' + e;
            update jiraLink;
        }        
        
        //Update new JIRA Reference
        system.debug('~~~oldJiraRerefence='+oldJiraRerefence);
        String newJiraRerefence = '';
        if(String.isBlank(oldJiraRerefence)){
            newJiraRerefence = JIRAID;
        }else{
            if(!oldJiraRerefence.contains(JIRAID)){
                newJiraRerefence = oldJiraRerefence+','+JIRAID;
            }else{
                return;
            }        
        }        
        
        //Set Method and Endpoint
        req.setMethod('PUT');
        req.setEndpoint(endpoint);
        
        String body = '{"update":{"'+jiraReferenceField+'":[{"set":"' + newJiraRerefence + '"}]}}';
        //String body = '{"update":{"customfield_12102":[{"set":"' + JIRAID + '"}]}}';
        //String body = '{"update":{"customfield_11801":[{"set":"' + JIRAID + '"}]}}';
        system.debug('~~~body='+body);
        req.setBody(body);
        
        try{
            res = http.send(req);
            system.debug('~~~res='+res.toString());
        }catch(Exception e){
            system.debug('Callout Exception: ' + e);
            system.debug('Req: ' + req);
            system.debug('Res: ' + res.toString());
            jiraLink.JIRA_Errors__c = 'Callout Exception: ' + e;
            update jiraLink;
        }
        
        try{
            system.debug('~~~res Status Code='+res.getStatusCode());
            if(res.getStatusCode()!=204){
                Map<String, Object> result_map = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                system.debug('~~~result_map='+result_map);
                if(result_map.containsKey('errors')){
                    Map<String, Object> results = (Map<String, Object>)result_map.get('errors');
                    system.debug('~~~results='+results);
                    errorMessage = '';
                    for(String k: results.keySet()){
                        errorMessage += k + ':' + (String)results.get(k) + '\n';
                    }
                    system.debug('~~~JIRA returned an error:'+errorMessage);
                    jiraLink.JIRA_Errors__c = 'JIRA returned error: ' + JSON.serialize(result_map);
                }
            }
        }catch(Exception e){
            system.debug('~~~Problem parsing returned JSON: '+res.getBody());
            system.debug('~~~Exception caught: '+e);
            jiraLink.JIRA_Errors__c = 'Error parsing returned JSON: '+e;
        }
        update jiraLink;    
    }
    
    
    //Update JIRA fields on creation of JIRA: Case Number, Case Status, Case URL
    //JIRAId: The 18 digit JIRA Link ID in Salesforce
    //JIRAName: The JIRA Link Name for the JIRA Link in Salesforce 
    @future(callout=true)
    public static void setJIRACaseFields(String JIRAId, String JIRAName){
        system.debug('~~~JIRAId='+JIRAId+', JIRAName='+JIRAName);
        init();
        String endpoint = jiraURL + '/rest/api/2/issue/' + JIRAName;
        system.debug('~~~endpoint='+endpoint);
        
        JIRA__c jiraLink = [SELECT Id, Name, JIRA_Errors__c, Case__c, Case__r.OwnerId, Case__r.Owner.Name, Case__r.CaseNumber, Case__r.Status FROM JIRA__c WHERE Id =: JIRAId limit 1];
        system.debug('~~~jiraLink='+jiraLink);
        
        //Set Method and Endpoint
        req.setMethod('PUT');
        req.setEndpoint(endpoint);
        
        if(String.isNotBlank(jiraLink.Case__c)){
                /*
            SFDC: Case Owner maps to JIRA: Assignee  (customfield_12602)
            SFDC: Case Number maps to JIRA: SFDC Case Number (customfield_12601) ~
            SFDC: Case Status maps to JIRA: SFDC Case Status (customfield_12600) ~
            SFDC: Case URL maps to JIRA: SFDC URL  (customfield_10702)*/
            
            String caseURL = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + jiraLink.Case__c;
            system.debug('~~~caseURL='+caseURL);
            
            String body = '{"update":{"customfield_12600":[{"set":"' + jiraLink.Case__r.Status + '"}],' + 
                          '"customfield_12601":[{"set":"' + jiraLink.Case__r.CaseNumber + '"}],' +
                          '"customfield_12707":[{"set":"' + jiraLink.Case__r.Owner.Name + '"}],' +
                          '"customfield_10702":[{"set":"' + caseURL + '"}] }}';
            
            
            system.debug('~~~body='+body);
            req.setBody(body);
            
            try{
                res = http.send(req);
                system.debug('~~~In setJIRACaseFields, try res, res.tostring= '+res.toString());
            }catch(System.CalloutException e){
                system.debug('~~~ Callout Exception ='+e);
                system.debug('~~~res.tostring='+res.toString());
                jiraLink.JIRA_Errors__c = 'CalloutException: '+e;
                update jiraLink;
                return;
            }
            
            try{
                system.debug('~~~res Status Code='+res.getStatusCode());
                if(res.getStatusCode()!=204){
                    Map<String, Object> result_map = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                    system.debug('~~~result_map='+result_map);
                    if(result_map.containsKey('errors')){
                        Map<String, Object> results = (Map<String, Object>)result_map.get('errors');
                        system.debug('~~~results='+results);
                        errorMessage = '';
                        for(String k: results.keySet()){
                            errorMessage += k + ':' + (String)results.get(k) + '\n';
                        }   
                        system.debug('~~~JIRA returned an error: '+errorMessage);
                        jiraLink.JIRA_Errors__c = 'JIRA returned error: '+JSON.serialize(result_map);
                    }
                    
                }
            
            }catch(Exception e){
                system.debug('~~~Problem parsing returned JSON: '+res.getBody());
                system.debug('~~~Exception caught: '+e);
                jiraLink.JIRA_Errors__c = 'Error parsing returned JSON: '+e;
            }
            update jiraLink;
        }
    }     
}