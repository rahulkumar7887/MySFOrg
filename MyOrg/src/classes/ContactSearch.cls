public class ContactSearch {
    public static List<Contact> searchForContacts(String str1, String str2){
        List<Contact> matchingCon = new List<Contact>();	
        Contact[] con = [Select Id, Name, LastName, MailingPostalCode from Contact];
        for(Contact c:con){
            if(c.LastName == Str1 && c.MailingPostalCode == str2){
                matchingCon.add(c);
            }
        }
        return matchingCon;
    }
}