@isTest
public class JiraTestHelper {
    // Test Support functions
    public static void testSupportHelper(){
        testSettingsHelper();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForJIRA());
    }
    
    public static void testErrorHelper(){
        testSettingsHelper();
        Test.setMock(HttpCalloutMock.class, new MockHttpErrorGeneratorForJIRA());
    }
    
    public static void testSettingsHelper(){
        List<JIRA_Settings__c> settings = new List<JIRA_Settings__c>();
        settings.add(new JIRA_Settings__c(Name='Username', Value__c='username'));
        settings.add(new JIRA_Settings__c(Name='Password', Value__c='passsword'));
        settings.add(new JIRA_Settings__c(Name='jiraURL', Value__c='jiraURL'));
        settings.add(new JIRA_Settings__c(Name='jiraReferenceField', Value__c='customfield_12102'));
        
        insert settings;
    }
}