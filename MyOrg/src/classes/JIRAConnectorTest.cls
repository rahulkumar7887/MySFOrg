// testing the various JIRA callouts
@isTest
private class JIRAConnectorTest {
    
    ////////////////////////
    //                    //
    //   Positive Tests   //
    //                    //
    ////////////////////////
    
    static testMethod void testGetLabelSuggestions() {
        JiraTestHelper.testSupportHelper();
        JIRAConnector.Suggestion s = new JIRAConnector.Suggestion('Label', 'HTML');
        Test.startTest();
            List<String> labels = JIRAConnector.getLabelSuggestions();
        Test.stopTest();
        system.assert(!labels.isEmpty());
    }
    
    static testMethod void testGetReportersManager() {
        JiraTestHelper.testSupportHelper();
        JIRAConnector.Suggestion s = new JIRAConnector.Suggestion('Name', 'HTML', 'DisplayName');
        Test.startTest();
            String managers = JIRAConnector.getReportersManager('Test');
        Test.stopTest();
        system.assertNotEquals(null, managers);
    }
    
    static testMethod void testQueryIssue() {
        JiraTestHelper.testSupportHelper();
        Test.startTest();
            JIRAConnector.init();
            List<JIRA_Issue__c> issues = JIRAConnector.queryIssue('Test');
        Test.stopTest();
        system.assertNotEquals(null, issues);
    }
    
    static testMethod void testCreateIssue(){
        JiraTestHelper.testSupportHelper();
        
        Case c = TestUtilities.createEmailToCaseRecs();
        insert c;
        
        JIRA__c link = new JIRA__c(Case__c = c.Id);
        insert link;
        
        JIRA_Issue__c issue = new JIRA_Issue__c();
        issue.JIRA_Link__c = link.Id;
        issue.Issue_Type__c = 'Triage';
        issue.Reporters_Manager__c = 'Test User';
        issue.Summary__c = 'Test Issue';
        issue.Department__c = 'Other';
        issue.Description__c = 'Test issue';
        issue.Components__c = '401k';
        issue.Employer_Console_Link__c = 'http://www.test.com';
        issue.Employee_Console_Link__c = 'http://www.test.com';
        issue.Lines_Of_Coverage__c = 'Medical';
        issue.Labels__c = 'Test';
        insert issue;
        
        Test.startTest();
            JIRAConnector.createIssue(issue.Id);
        Test.stopTest();
        
        link = [SELECT Summary__c, Ticket_Status__c FROM JIRA__c WHERE ID =: link.Id];
        
        system.assertEquals(issue.Summary__c, link.Summary__c);
        system.assertEquals('Open', link.Ticket_Status__c);
    }
    
    static testMethod void testAssociateIssue(){
        JiraTestHelper.testSupportHelper();
        
        Case c = TestUtilities.createEmailToCaseRecs();
        insert c;
        
        JIRA__c link = new JIRA__c(Case__c = c.Id);
        insert link;
        
        String key = 'Test-01';
        
        JIRAHelper.createFromVF = true;
        
        Test.startTest();
            JIRAConnector.associateIssue(link.Id, key);
        Test.stopTest();
        
        link = [SELECT Name,JIRA_Errors__c FROM JIRA__c WHERE ID =: link.Id];
        
        system.assertNotEquals(null, link.JIRA_Errors__c);
    }
    
    ////////////////////////
    //                    //
    //   Negative Tests   //
    //                    //
    ////////////////////////
    
    static testMethod void testGetLabelSuggestionsError() {
        JiraTestHelper.testErrorHelper();
        JIRAConnector.Suggestion s = new JIRAConnector.Suggestion('Label', 'HTML');
        Test.startTest();
            List<String> labels = JIRAConnector.getLabelSuggestions();
        Test.stopTest();
        system.assertEquals(null, labels);
    }
    
    static testMethod void testGetReportersManagerError() {
        JiraTestHelper.testErrorHelper();
        JIRAConnector.Suggestion s = new JIRAConnector.Suggestion('Name', 'HTML', 'DisplayName');
        Test.startTest();
            String managers = JIRAConnector.getReportersManager('Test');
        Test.stopTest();
        system.assertEquals(null, managers);
    }
    
    static testMethod void testQueryIssueError() {
        JiraTestHelper.testErrorHelper();
        Test.startTest();
            JIRAConnector.init();
            List<JIRA_Issue__c> issues = JIRAConnector.queryIssue('Test');
        Test.stopTest();
        system.assertEquals(null, issues);
    }
    
    static testMethod void testCreateIssueError(){
        JiraTestHelper.testErrorHelper();
        
        Case c = TestUtilities.createEmailToCaseRecs();
        insert c;
        
        JIRA__c link = new JIRA__c(Case__c = c.Id);
        insert link;
        
        JIRA_Issue__c issue = new JIRA_Issue__c();
        issue.JIRA_Link__c = link.Id;
        issue.Issue_Type__c = 'Triage';
        issue.Reporters_Manager__c = 'Test User';
        issue.Summary__c = 'Test Issue';
        issue.Department__c = 'Other';
        issue.Description__c = 'Test issue';
        issue.Components__c = '401k';
        issue.Employer_Console_Link__c = 'http://www.test.com';
        issue.Employee_Console_Link__c = 'http://www.test.com';
        issue.Lines_Of_Coverage__c = 'Medical';
        issue.Labels__c = 'Test';
        insert issue;
        
        Test.startTest();
            JIRAConnector.createIssue(issue.Id);
        Test.stopTest();
        
        link = [SELECT JIRA_Errors__c FROM JIRA__c WHERE ID =: link.Id];
        
        system.assertNotEquals(null, link.JIRA_Errors__c);
    }
    
    static testMethod void testAssociateIssueError(){
        JiraTestHelper.testErrorHelper();
        
        Case c = TestUtilities.createEmailToCaseRecs();
        insert c;
        
        JIRA__c link = new JIRA__c(Case__c = c.Id);
        insert link;
        
        Test.startTest();
            JIRAConnector.associateIssue(link.Id, 'Test-01');
        Test.stopTest();
        
        link = [SELECT JIRA_Errors__c FROM JIRA__c WHERE ID =: link.Id];
        
        system.assertNotEquals(null, link.JIRA_Errors__c);
    }
}