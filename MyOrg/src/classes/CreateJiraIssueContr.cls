public with sharing class CreateJiraIssueContr {

    public JIRA__c jiraObj {get; set;}
    public ID idCaseObj {get; set;}
    public String errorMessage;
    public JIRA_Issue__c issue {get; set;}
    
    public CreateJiraIssueContr(ApexPages.StandardController controller) {
        idCaseObj = ApexPages.currentPage().getParameters().get('ID');
        System.debug('CaseID' + idCaseObj);
        issue = new JIRA_Issue__c();
    }
        
    public PageReference fnCreateTicket(){
        try{
            // Create a new link object
            jiraObj = new JIRA__c();
            jiraObj.Case__c = idCaseObj;
            insert jiraObj;
            issue.JIRA_Link__c = jiraObj.Id;
            insert issue;
            // call method to create jira issue.
            JIRAIntegrator.createIssue(issue.Id);
            //JIRAConnector.createIssue(issue.Id);
            //JIRAWebserviceCalloutSyncFields.syncfields(idCaseObj); 
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
}