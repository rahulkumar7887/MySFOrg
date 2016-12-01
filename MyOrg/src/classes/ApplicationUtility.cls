public class ApplicationUtility {

    /***
        Purpose    : Fetch Profile Name of the current user
        Return     : String - Profile Name
    ***/
    private static String getProfileName(){
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName'+ profileName);
        return profileName;
    }
    
}