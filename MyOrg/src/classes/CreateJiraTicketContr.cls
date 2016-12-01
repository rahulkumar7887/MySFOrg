public with sharing class CreateJiraTicketContr {
    public JIRA__c jiraObj {get; set;}
    public ID idCaseObj {get; set;}
    public String errorMessage;
    public JIRA_Issue__c issue {get; set;}
    
    public List<String> label_suggestions {get;set;}
    
    public CreateJiraTicketContr(){
        idCaseObj = ApexPages.currentPage().getParameters().get('caseID');
        issue = new JIRA_Issue__c();
        label_suggestions = JIRAConnector.getLabelSuggestions();
        if(label_suggestions != null){
            label_suggestions.sort();
        }
    }
    
    public PageReference fnCreateTicket(){
        try{
            JIRAHelper.createFromVF = true;
            system.debug('~~~In CreateJiraTicketContr - PageReference fnCreateTicket, set JIRAHelper.createFromVF to true');
            
            // Create a new link object
            jiraObj = new JIRA__c();
            jiraObj.Case__c = idCaseObj;
            insert jiraObj;
            issue.JIRA_Link__c = jiraObj.Id;
        
            insert issue;
            
            
            JIRAConnector.createIssue(issue.Id);
            return new PageReference('/' + jiraObj.Id);
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occurred: ' + e));
        }
        return null;
    }
    
    public PageReference cancel(){
        return new PageReference('/' + idCaseObj);
    }
    
    @RemoteAction
    public static String getManagersRemote(String name){
        String managers = JIRAConnector.getReportersManager(name);
        system.debug('managers: ' + managers);
        return managers;
    }
}