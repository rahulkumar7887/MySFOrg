@isTest(SeeAllData=false)
public class UserTest{
    static testMethod void UTest() {
        Profile profile = new Profile();
        profile = [Select Id, Name from Profile where Name='Custom: Sales Profile'];  

        User usr = new User(alias = 'testusr', email='standarduser@testing.com', 
                            emailencodingkey='UTF-8',lastname='testing',
                            languagelocalekey='en_US', 
                            localesidkey='en_US', ProfileId = profile.id,    //'00ej0000000s4Fl',
                            timezonesidkey='America/Los_Angeles',
                            username='standahhhhhhhrduser@testorg.com');
        
        System.runAs(usr) {        
        System.debug('Currentuser:' + UserInfo.getUserName());
        System.debug('CurrentProfile:' + UserInfo.getProfileId());
        }
    }
}