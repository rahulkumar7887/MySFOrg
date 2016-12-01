public with sharing class loginPageController {

    public String username{set; get;}
    public String password{set; get;}
    
    Contact cont;
    
    public loginPageController(ApexPages.StandardController controller) {
        cont = (Contact)controller.getRecord();
    }
    
    public PageReference signIn(){
    
        //system.debug('####' + cont.username__c);
        //system.debug('####' + cont.password__c);
        
        List<Contact> cList = [Select Id, username__c,password__c from Contact where username__c =: cont.username__c];
        for(Contact con: cList) {
            //system.debug('@@@@' + cList);
            //system.debug('#####' + con.username__c);
            if(((cont.username__c).equals(con.username__c)) && ((cont.password__c).equals(con.password__c))) {
                PageReference pageRef = new PageReference('/apex/home');
                //pageRef.setRedirect(true);
                return pageRef;
            }/*
            else {
                PageReference pageRef = new PageReference('/apex/UnderConstruction');
                pageRef.setRedirect(true);
                return pageRef;
            }   */         
        }
        return null;                 
    }
    
    public PageReference forgotPassword(){
        PageReference pageRef = new PageReference('/apex/forgotPassword');
        pageRef.setRedirect(true);
        return pageRef;    
    }
    public PageReference signUp(){
        PageReference pageRef = new PageReference('/apex/signUp');
        pageRef.setRedirect(true);
        return pageRef;    
    }
}