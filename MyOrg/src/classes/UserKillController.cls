public with sharing class UserKillController {

    public Boolean refreshPage { get; set; }
    
    public Integer DAYOFMONTH = 15; 
    
    public userKillController(ApexPages.StandardController controller) {
    
    }
    
    public PageReference killUser() {
    
        Date todayDate = date.Today();
        Integer day = todayDate.day();
                           
        String Id = ApexPages.currentPage().getParameters().get('id');
        
        if(day <= DAYOFMONTH ) {
            UserLogin ulobj =  [SELECT Id, IsFrozen FROM UserLogin WHERE userId =: Id];
            ulobj.IsFrozen = true;
            
            update ulobj;
            
            refreshPage  = true; 
        }   
        else {
            List<User> userToDelete = new List<User>();
          //  for(User userObj : [Select Id,IsActive from User where Id =: Id]){
                //if(userObj.IsActive){
                   // userObj.IsActive = false;
                   // userToDelete.add(userObj);
               // }
          //  }
           // update userToDelete;
            
            refreshPage  = true;
        }        
        return null;
    }    
}