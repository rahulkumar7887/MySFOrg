public class ContactAndLeadSearch {
    public static List<List< SObject>> searchContactsAndLeads(String str){
        Contact con = new Contact(LastName = 'Smith');
        insert con;
        
        Lead led = new Lead(LastName = 'Smith', Company = 'Acc');
        insert led;
        
        List<List<SObject>> result = [FIND :str RETURNING Contact(FirstName, LastName), Lead(FirstName, LastName)];
        
        return result;        
    }
}