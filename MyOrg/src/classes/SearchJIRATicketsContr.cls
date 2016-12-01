public with sharing class SearchJIRATicketsContr {
    private ApexPages.StandardController controller;
    public Case caseObj { get; set; }
    public Case cObj;
    public JIRA__c jiraObj { get; set; }
    public String strSearchText {get;set;}
    public list<JIRA_Issue__c> lstResults {get; set;}
    public Boolean showResultSection {get;set;}
    public Boolean showNewTicketSection {get;set;}
    public String issueKey {get;set;}
    
    public SearchJIRATicketsContr(ApexPages.StandardController controller) {
       try {
           this.controller = controller;
           cObj = (Case) controller.getRecord();        
           showResultSection = false;
           showNewTicketSection = false;
           // Get the Case record
           caseObj = [select id,AccountID from Case where id=:cObj.id];                                    
                   
       } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
       }
    }
    
    /* This method will make a callout to JIRA API. To search for given text in jira ticket's subject column.*/
    public Pagereference fnSearchProcess(){  
        showResultSection = false;
        showNewTicketSection = false;
        if(strSearchText == null || strSearchText == ''){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter the search text.'));
            return null;
        }       
        
        // Callout and processing       
        JIRAConnector.init();
        if(JIRAConnector.errorMessage == null){
            
            lstResults = new list<JIRA_Issue__c>();
            lstResults = JIRAConnector.queryIssue(strSearchText);       
            
            system.debug('~~~In fnSearchProcess, lstResults='+lstResults);
            
            /* Results processing */
            if(lstResults.size()>0){ // 1. Found
                // Display the tickets for user to select
                    if(lstResults.size()>0){
                        showResultSection = true;
                    }
            }       
            else{ // 2. Not found - show create new ticket link and new jira object
                // Show message
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'No Results Found.'));
                showNewTicketSection = true;
                return null;
            }           
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, JIRAConnector.errorMessage));
            return null;
        }
        // will return list of tickets   
        return null;
    }
    
    /* This method will be called when user has selected the ticket and clicked Associate button*/
    public Pagereference fnAssociate(){
        system.debug('~~~In fnAssociate, issueKey='+issueKey);
        // Create a new link object
        JIRAHelper.createFromVF = true;
        system.debug('~~~In SearchJIRATicketsContr - PageReference fnAssociate, set JIRAHelper.createFromVF to true');
        jiraObj = new JIRA__c();
        jiraObj.Case__c = caseObj.id;
        insert jiraObj;     
        system.debug('~~~Inserted jiraObj='+jiraObj);
        system.debug('associating issue: ' + issueKey);
        JIRAConnector.associateIssue(jiraObj.Id, issueKey);
        
        return new PageReference('/'+jiraObj.Id);
    }
    
    /* This method will be called user clicks create button*/
    public Pagereference fnCreate(){        
        Pagereference jiraCreateLink = Page.CreateJiraTicket;       
        jiraCreateLink.getParameters().put('caseID',caseObj.id); 
        jiraCreateLink.setRedirect(true);           
        return jiraCreateLink;
    }
    
    public PageReference cancel(){
        return controller.cancel();
    }  
}