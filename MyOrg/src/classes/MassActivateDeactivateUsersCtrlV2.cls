public class MassActivateDeactivateUsersCtrlV2 {
	
    static List<User> selectedList = new List<User>();
    List<UserWrapper> lstWrapperUsers{get;set;}
    
    public Integer recordsPerPage{get;set;}
    public boolean test = false;

    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Name, IsActive, Username, UserRole.Name, Profile.Name, Email From User]));
                // sets the number of records in each page set
                if(test == false){
                    recordsPerPage = 10;
                    test = true;
                }
                con.setPageSize(recordsPerPage);
            }
            return con;
        }
        set;
    }
    
    // returns a list of wrapper objects for the sObjects in the current page set
    public List<UserWrapper> getlstWrapperUsers(){
        lstWrapperUsers = new List<UserWrapper>();
        
        for (User userRec: (List<User>)con.getRecords()){
            lstWrapperUsers.add(new UserWrapper(userRec));
        }
        System.debug('##lstWrapperUsers' + lstWrapperUsers);
        return lstWrapperUsers;
    }
    
    // displays the selected items
	public PageReference activateUsers() {
		for(UserWrapper userWrapper: lstWrapperUsers){
			if(userWrapper.selected == true){
				selectedList.add(userWrapper.userRecord);
			}
		}
		System.debug('##selected##' + selectedList);
        activateDeactivateUsers(selectedList, 'Activate');
		return null;
	}
    
    // displays the selected items
	public PageReference deactivate() {
		for(UserWrapper userWrapper: lstWrapperUsers){
			if(userWrapper.selected == true){
				selectedList.add(userWrapper.userRecord);
			}
		}
		System.debug('##selected##' + selectedList);
        activateDeactivateUsers(selectedList, 'Deactivate');
		return null;
	}
    
    public void activateDeactivateUsers(List<User> lstUsers, String actOrDeact){
        List<User> actOrDeactUserList = new List<User>();
        for(User user: lstUsers){
            if(actOrDeact == 'Activate'){
            	user.IsActive = true;
                actOrDeactUserList.add(user);
        	}
            else if(actOrDeact == 'Deactivate'){
            	user.IsActive = false;
                actOrDeactUserList.add(user);
        	}
        }
        update actOrDeactUserList;
    }
    
    // returns the first page of records
    public void first() {
        con.first();
    }
	
    // returns the last page of records
    public void last() {
        con.last();
    }
    
    // returns the next page of records
    public void next() {
    	for(UserWrapper userWrapper: lstWrapperUsers){
			if(userWrapper.selected == true){
				selectedList.add(userWrapper.userRecord);
			}
		}
		System.debug('##selected##' + selectedList);
		con.next();
    }
    
    // returns the previous page of records
    public void previous() {
        con.previous();
    }
    
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
    
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
    
    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        con.cancel();
    }

	public class UserWrapper {
        public User userRecord{get;set;}
        public Boolean selected{get;set;}
    
        public UserWrapper(User u){
            userRecord = u;
            selected = false;
        }
	}
	
    public List<selectOption> userRoleOptions {
    get {
            List<selectOption> roleName = new List<selectOption>();
            roleName.add(new selectOption('Value', 'Select User Role')); // 'Value', 'Label'
            for (UserRole ur : [select Name from UserRole])
                 roleName.add(new selectOption(ur.Name,ur.Name)); // one for name which is displayed and another for value
            return roleName;
    }
    private set;}
	
	public List<selectOption> userProfileOptions {
    get {
            List<selectOption> profileName = new List<selectOption>();
            profileName.add(new selectOption('Value', 'Select User Profile')); // 'Value', 'Label'
            for (Profile profile : [select Name from Profile])
                 profileName.add(new selectOption(profile.Name,profile.Name)); // one for name which is displayed and another for value
            return profileName;
    }
    private set;}
	    
    public pageReference refresh() {
		con = null;
        getlstWrapperUsers();
        con.setPageNumber(1);
        return null;
    }    
}