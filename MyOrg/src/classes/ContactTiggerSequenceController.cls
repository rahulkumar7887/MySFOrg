public class ContactTiggerSequenceController {
    
    public static void executeBeforeInsert(List<Contact> cListNew) {
        ContactTiggerHandler.updateAccountsRelatedContacts(cListNew);
        ContactTiggerHandler.updateNumberOfContacts(cListNew);        
    }
    
    public static void executeBeforeUpdate(List<Contact> cListNew, List<Contact> cListOld) {
    	ContactTiggerHandler.changeLastModifiedDate(new Map<Id,Contact>(cListNew), new Map<Id,Contact>(cListOld));        
    }
    
    public static void executeBeforeDelete(List<Contact> cList){
    	ContactTiggerHandler.updateAccountsRelatedContacts(cList);
		ContactTiggerHandler.removeNumberOfContacts(cList);         
    }
    
    public static void executeAfterInsert(List<Contact> cList){
    	//ContactTiggerHandler.createAccount(cList);      
    }
    
    public static void executeAfterUpdate(List<Contact> cList){
    	//ContactTiggerHandler       
    }
    
    public static void executeAfterDelete(List<Contact> cListOld, List<Contact> cListNew) {
    	//ContactTiggerHandler    
    }   
}