/**********************************************************
//Created by: 
//Last Modified: 
//
//Description:
//Test class for JIRALinkTriggerHandler
**********************************************************/
@isTest
private class JIRALinkTriggerHandlerTest {
    //Created by: Tracy Guo
    //Test JIRA Link creation - associate with JIRA ticket
    public static testMethod void testJIRALinkReference(){
     /*   User testUser = testSetupUser();
        insert testUser;
        
        JiraTestHelper.testSupportHelper();
        
        Case c = TestUtilities.createEmailToCaseRecs();
        insert c;
        
        JIRA__c link = new JIRA__c(Case__c = c.Id);
        
        Test.startTest();
        
        system.runAs(testUser){
            insert link;
        }
        
        Test.stopTest();
        
        link = [SELECT ID, Case__c, Name, JIRA_Errors__c FROM JIRA__c WHERE id=: link.id limit 1];
        system.assertEquals(c.id, link.case__c);
        system.assertNotEquals(null, link.JIRA_Errors__c); */
        
    }    

/*
    private static User testSetupUser(){
        Profile sp = [SELECT Id FROM profile WHERE name='System Administrator'];
        User testUser = new User(alias = 'uxxx1', email='test@test.com', emailencodingkey='UTF-8', lastname='Testing', 
            languagelocalekey='en_US', localesidkey='en_US', profileid = sp.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='test321CBA@test.com'); 
        return testUser;
    }*/
}