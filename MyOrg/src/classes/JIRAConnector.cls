public with sharing class JIRAConnector {
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
    }
    
    // Description: 
    // Queries JIRA for a list of all label suggestions
    //
    // Returns: List<String> of possible label suggestions from JIRA
    public static List<String> getLabelSuggestions(){
        init();
        String endpoint = jiraURL + '/rest/api/1.0/labels/suggest?query=';
        
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        
        // query JIRA
        try{
            res = http.send(req);
        }
        catch(System.CalloutException e){
            system.debug('Callout Exception: ' + e);
            system.debug('Req: ' + req);
            system.debug('Res: ' + res.toString());
            errorMessage = 'Unable to contact JIRA server: ' + e;
            return null;
        }
        
        List<String> labels = new List<String>();
        
        try{
            Map<String, Object> result_map = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            
            // if the query failed, most likely due to the supplied key not being found, processing stops and an error is returned 
            if(result_map.containsKey('errorMessages')){
                List<Object> results = (List<Object>)result_map.get('errorMessages');
                errorMessage = (String)results.get(0);
                system.debug('JIRA returned an error: ' + errorMessage);
                return null;
            }
            List<Suggestion> suggestions_list = (List<Suggestion>)JSON.deserialize(JSON.serialize(result_map.get('suggestions')), List<Suggestion>.class);
            
            for(Suggestion s : suggestions_list){
                labels.add(s.label);
            }
        }
        catch(Exception e){
            
        }
        return labels;
    }
    
    // Description: auto complete method for Reporter's Manager field in JIRA
    //
    // Input: name
    //
    // Returns: list of names of possible managers based on input, serialized as
    // JSON name/value pairs ("display name: name" from JIRA) for use in javascript
    // auto-complete function
    public static String getReportersManager(String name){
        init();
        String endpoint = jiraURL + '/rest/api/1.0/users/picker?fieldName=customfield_11401&query=' + name;
        
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        
        // query JIRA
        try{
            res = http.send(req);
        }
        catch(System.CalloutException e){
            system.debug('Callout Exception: ' + e);
            system.debug('Req: ' + req);
            system.debug('Res: ' + res.toString());
            errorMessage = 'Unable to contact JIRA server: ' + e;
            return null;
        }
        
        String suggestions = '[';
        
        try{
            Map<String, Object> result_map = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            
            // if the query failed, most likely due to the supplied key not being found, processing stops and an error is returned 
            if(result_map.containsKey('errorMessages')){
                List<Object> results = (List<Object>)result_map.get('errorMessages');
                errorMessage = (String)results.get(0);
                system.debug('JIRA returned an error: ' + errorMessage);
                return null;
            }
            
            List<Suggestion> suggestions_list = (List<Suggestion>)JSON.deserialize(JSON.serialize(result_map.get('users')), List<Suggestion>.class);
            
            for(Suggestion s : suggestions_list){
                suggestions += '{"label": "' + s.displayName + '", "value": "' + s.name + '"},';
            }
            suggestions = suggestions.removeEnd(',') + ']';
        }
        catch(Exception e){
            system.debug('Exception occurred while processing results' + e);
            return null;
        }
        return suggestions;
    }
    
    // Description:
    // Finds all issues containing the summary string
    //
    // Input: String containing search parameter
    //
    // Returns: List<JIRA_Issue__c> that has all the JIRA issues
    // returned by the search
    public static List<JIRA_Issue__c> queryIssue(String summary){
        errorMessage = null;
        String endpoint = jiraURL + '/rest/api/2/search?jql=summary~' + summary + '&fields=key,summary,type,priority,status';
        
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        
        // query JIRA
        try{
            res = http.send(req);
        }
        catch(System.CalloutException e){
            system.debug('Callout Exception: ' + e);
            system.debug('Req: ' + req);
            system.debug('Res: ' + res.toString());
            errorMessage = 'Unable to contact JIRA server: ' + e;
            return null;
        }
        
        
        List<JIRA_Issue__c> lstIssues = new List<JIRA_Issue__c>();
        
        try{
            Map<String, Object> result_map = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            
            // if the query failed, most likely due to the supplied key not being found, processing stops and an error is returned 
            if(result_map.containsKey('errorMessages')){
                List<Object> results = (List<Object>)result_map.get('errorMessages');
                errorMessage = (String)results.get(0);
                system.debug('JIRA returned an error: ' + errorMessage);
                return null;
            }
            
            // otherwise process the results and return issue
            List<Object> issues = (List<Object>)result_map.get('issues');
            
            for(Object obj : issues){
                JIRA_Issue__c issue = new JIRA_Issue__c();
                //Map<String, Object> issue_map = (Map<String, Object>)issues.get(0);
                Map<String, Object> issue_map = (Map<String, Object>)obj;
                
                // issue subject - alias for key
                issue.key__c = (String)issue_map.get('key');
                
                Map<String, Object> fields_map = (Map<String, Object>)issue_map.get('fields');
                if(fields_map != null) issue.summary__c = (String)fields_map.get('summary');
                
                Map<String, Object> priority_map = (Map<String, Object>)fields_map.get('priority');
                if(priority_map != null) issue.priority__c = (String)priority_map.get('name');
                
                Map<String, Object> status_map = (Map<String, Object>)fields_map.get('status');
                if(status_map != null) issue.status__c = (String)status_map.get('name');
                
                lstIssues.add(issue);
            }
            
        }
        catch(Exception e){
            system.debug('Problem parsing returned JSON: ' + res.getBody());
            system.debug('Exception caught: ' + e);
            errorMessage = 'A problem occurred while parsing results from JIRA: ' + e;
            return null;
        }
        
        return lstIssues;
    }
    
    // Description:
    // Associates selected JIRA Issue to the current case
    // 
    // Input: Id of newly created JIRA__c record and key for
    // selected JIRA issue to be associated
    // 
    // Returns: No actual return value but will update JIRA__c
    // record on completion with either the key (on success)
    // or an error message (on failure)
    @future (callout=true)
    public static void associateIssue(Id JIRA_Id, String key){
        system.debug('~~~In associateIssue, key='+key+', JIRA_Id='+JIRA_Id);
        init();
        String endpoint = jiraURL + '/rest/api/2/issue/' + key;
        
        system.debug('~~~endpoint='+endpoint);
        system.debug('~~~jiraReferenceField='+jiraReferenceField);

        JIRA__c jiraLink = [SELECT Id, Name, JIRA_Errors__c, Case__c, Case__r.OwnerId, Case__r.Owner.Name, Case__r.CaseNumber, Case__r.Status FROM JIRA__c WHERE Id =: JIRA_Id limit 1];
        system.debug('~~~jiraLink='+jiraLink);
        
        
        
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
        
        
        }catch(Exception e){
            system.debug('~~~Problem parsing returned JSON for GET: ' + res.getBody());
            system.debug('~~~Exception caught: ' + e);
            jiraLink.JIRA_Errors__c = 'Problem parsing returned JSON for GET:' + e;
            update jiraLink;
        
        }
        
        //Update new JIRA Reference
        system.debug('~~~oldJiraRerefence='+oldJiraRerefence);
        String newJiraRerefence = '';
        if(String.isBlank(oldJiraRerefence)){
            newJiraRerefence = JIRA_Id;
        }else{
            if(!oldJiraRerefence.contains(JIRA_Id)){
                newJiraRerefence = oldJiraRerefence+','+JIRA_Id;
            }else{
                return;
            }
        
        }
        
            
                    
        //Set Method and Endpoint
        req.setMethod('PUT');
        req.setEndpoint(endpoint);
        
        String caseURL = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + jiraLink.Case__c;
        system.debug('~~~caseURL='+caseURL);
        
        String body = '{"update":{"'+jiraReferenceField+'":[{"set":"' + newJiraRerefence + '"}],' +
                      '"customfield_12600":[{"set":"' + jiraLink.Case__r.Status + '"}],' +
                      '"customfield_12601":[{"set":"' + jiraLink.Case__r.CaseNumber + '"}],' +
                      '"customfield_12707":[{"set":"' + jiraLink.Case__r.Owner.Name + '"}],' +
                      '"customfield_10702":[{"set":"' + caseURL + '"}] }}'; 
        
        system.debug('~~~body='+body);
        req.setBody(body);
        
        
       // req.setBody('{"update":{"customfield_11801":[{"set":"' + JIRA_Id + '"}]}}');
        

            
        system.debug('~~~jiraLink='+jiraLink);    
            
        try{
            res = http.send(req);
            system.debug('try Res: ' + res.toString());
        }
        catch(System.CalloutException e){
            system.debug('Callout Exception: ' + e);
            system.debug('Req: ' + req);
            system.debug('Res: ' + res.toString());
            jiraLink.JIRA_Errors__c = 'Callout Exception: ' + e;
            update jiraLink;
        }
        
        try{
            if(res.getStatusCode() == 204){
                system.debug('~~~status code is 204, going to update Jira Link Name to: '+key);
                jiraLink.Name = key;
            }
            else{
                system.debug('body: ' + res.getBody());
                Map<String, Object> result_map = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                system.debug('result_map: ' + result_map);
                // if the insert failed, an error is returned 
                if(result_map.containsKey('errors')){
                    Map<String, Object> results = (Map<String, Object>)result_map.get('errors');
                    errorMessage = '';
                    for(String k : results.keySet()){
                        errorMessage += k + ': ' + (String)results.get(k) + '\n';
                    }
                    system.debug(result_map);
                    system.debug('JIRA returned an error: ' + errorMessage);
                    jiraLink.JIRA_Errors__c = JSON.serialize(result_map);
                }
            }
        }
        catch(Exception e){
            system.debug('Problem parsing returned JSON: ' + res.getBody());
            system.debug('Exception caught: ' + e);
            jiraLink.JIRA_Errors__c = 'Error parsing returned JSON: ' + e;
        }
        update jiraLink;
    }
    
    // Description:
    // Creates a new JIRA Issue in the JIRA database and associates
    // it to the current case
    // 
    // Input: Id of newly created JIRA_Issue__c record that contains
    // all the information for the issue to be created - data validation
    // must occur prior to method execution
    // 
    // Returns: No actual return value but will update JIRA__c
    // record on completion with either the key (on success)
    // or an error message (on failure)
    @future (callout=true)
    public static void createIssue(Id issueID){
        init();
        String endpoint = jiraURL + '/rest/api/2/issue/';
        
        system.debug('endpoint: ' + endpoint);
        system.debug('~~~In createIssue, jiraReferenceField='+jiraReferenceField);
        
        JIRA_Issue__c new_issue = [SELECT Client_Name__c, COBRA_Census_Console_Link__c, Company_COBRA_Type__c, Components__c,
            Cooling_Off_Period__c, Current_COBRA_Administrator__c, Department__c, Description__c, Due_Date__c, 
            Employee_Console_Link__c, Employer_Console_Link__c, Exception_Type__c, Issue_Type__c, JIRA_Link__c, Labels__c,
            Lines_of_Coverage__c, Link_to_Sync_Log__c, Payroll_Provider__c, Priority__c, Project__c, Reporters_Manager__c,
            Summary__c, Team__c, Temp_Credentials_or_Email_Address__c FROM JIRA_Issue__c WHERE ID =: issueID];
        
                
        JIRA__c link = [SELECT Id, Name, JIRA_Errors__c, Case__c, Case__r.OwnerId, Case__r.Owner.Name, Case__r.CaseNumber, Case__r.Status FROM JIRA__c 
            WHERE Id =: new_issue.JIRA_Link__c];
            
        //Set Method and Endpoint
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        
        String caseURL = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + link.Case__c;
        system.debug('~~~caseURL='+caseURL);

        // create issue body
        String body = '{"fields":{"project":{"key":"' + new_issue.Project__c + '"},"issuetype":{"name":"' 
            + new_issue.issue_type__c + '"}';
        
        if(new_issue.reporters_manager__c != null){
            body += ', "customfield_11401":{"name":"' + new_issue.reporters_manager__c + '"}'; 
        }
        if(new_issue.department__c != null){
            body += ', "customfield_10504":{"value":"' + new_issue.Department__c + '"'; 
            if(new_issue.Team__c != null){
                body += ', "child": {"value": "' + new_issue.Team__c + '"}'; 
            }
            body += '}';
        }
        if(new_issue.components__c != null){ 
            body += ', "components": [{"name":"' + new_issue.components__c + '"}]';
        }
        if(new_issue.employee_console_link__c != null){
            body += ', "customfield_10803": "' + new_issue.employee_console_link__c + '"';
        }
        if(new_issue.employer_console_link__c != null){
            body += ', "customfield_10700": "' + new_issue.employer_console_link__c + '"';
        }
        if(new_issue.client_name__c != null){
            body += ', "customfield_10506": "' + new_issue.client_name__c + '"';
        }
        if(new_issue.description__c != null){
            body += ', "description": "' + new_issue.description__c + '"';
        }
        if(new_issue.summary__c != null){
            body += ', "summary": "' + new_issue.summary__c + '"';
        }
        if(new_issue.labels__c != null){ 
            body += ', "labels": ["' + new_issue.labels__c.deleteWhitespace().removeEnd(',').replace(',', '","') + '"]';
        }
        if(new_issue.JIRA_Link__c != null){
            //body += ', "customfield_11801":"' + new_issue.JIRA_Link__c + '"';
            //body += ', "customfield_12102":"' + new_issue.JIRA_Link__c + '"';
            body += ', "'+jiraReferenceField+'":"' + new_issue.JIRA_Link__c + '"';
        }
        if(link.Case__c!=null){
            if(link.Case__r.Status != null){
                body += ', "customfield_12600":"' + link.Case__r.Status + '"';  
            }
            if(link.Case__r.CaseNumber != null){
                body += ', "customfield_12601":"' + link.Case__r.CaseNumber + '"';  
            }
            if(caseURL != null){
                body += ', "customfield_10702":"' + caseURL + '"';  
            }
            /*
            if(link.Case__r.Owner.Name !=null){
                body += ', "customfield_12707":"' + link.Case__r.Owner.Name + '"';  
            }*/
        }
        if(new_issue.COBRA_Census_Console_Link__c != null){
            body += ', "customfield_11321":"' + new_issue.COBRA_Census_Console_Link__c + '"';
        }
        if(new_issue.Company_COBRA_Type__c != null){
            body += ', "customfield_11322":{"value":"' + new_issue.Company_COBRA_Type__c + '"}';
        }
        if(new_issue.Cooling_Off_Period__c != null){
            body += ', "customfield_11324":"' + new_issue.Cooling_Off_Period__c + '"';
        }
        if(new_issue.Current_COBRA_Administrator__c != null){
            body += ', "customfield_11323":"' + new_issue.Current_COBRA_Administrator__c + '"';
        }
        if(new_issue.Due_Date__c != null){
            body += ', "duedate":"' + new_issue.Due_Date__c + '"';
        }
        if(new_issue.Exception_Type__c != null){
            body += ', "customfield_11000":{"value":"' + new_issue.Exception_Type__c + '"}';
        }
        if(new_issue.Lines_of_Coverage__c != null){
            body += ', "customfield_11400":[{"value":"' + new_issue.Lines_of_Coverage__c.replace(';', '"},{"value":"') + '"}]';
        }
        if(new_issue.Link_to_Sync_Log__c != null){
            body += ', "customfield_11102":"' + new_issue.Link_to_Sync_Log__c + '"';
        }
        if(new_issue.Payroll_Provider__c != null){
            body += ', "customfield_11311":"' + new_issue.Payroll_Provider__c + '"';
        }
        if(new_issue.Temp_Credentials_or_Email_Address__c != null){
            body += ', "customfield_11318":"' + new_issue.Temp_Credentials_or_Email_Address__c + '"';
        }
        
        body += '}}';
        system.debug('~~~body='+body);
        req.setBody(body);

        
        try{
            res = http.send(req);
            
            system.debug(body);
            system.debug('in try Res: ' + res.toString());
            system.debug((Map<String, Object>)JSON.deserializeUntyped(res.getBody()));
        }
        catch(System.CalloutException e){
            system.debug('Callout Exception: ' + e);
            system.debug('Req: ' + req);
            system.debug('Res: ' + res.toString());
            link.JIRA_Errors__c = 'Callout Exception: ' + e;
            update link;
            return;
        }
        
        try{
            Map<String, Object> result_map = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            
            // if the insert failed, an error is returned 
            if(result_map.containsKey('errors')){
                Map<String, Object> results = (Map<String, Object>)result_map.get('errors');
                errorMessage = '';
                for(String key : results.keySet()){
                    errorMessage += key + ': ' + (String)results.get(key) + '\n';
                }
                system.debug(result_map);
                system.debug('JIRA returned an error: ' + errorMessage);
                link.JIRA_Errors__c = errorMessage;
            }
            else{
                String key = (String)result_map.get('key');
                link.Name = key;
                link.Summary__c = new_issue.Summary__c;
                link.Ticket_Status__c = 'Open';
            }
        }
        catch(Exception e){
            system.debug('Problem parsing returned JSON: ' + res.getBody());
            system.debug('Exception caught: ' + e);
            link.JIRA_Errors__c = 'Error parsing returned JSON: ' + e;
        }
        update link;
    }
    
    // Description:
    // Used to deserialize returned JSON in the getLabelSuggestions() method
    // and getReportersManager() method
    public class Suggestion{
        String html;
        String label;
        String name;
        String displayName;
        
        public suggestion(String h, String l){
            html = h;
            label = l;
        }
        
        public suggestion(String n, String h, String d){
            name = n;
            html = h;
            displayName = d;
        }
    }
    

}