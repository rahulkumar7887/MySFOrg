global class CleanUpRecords implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'select email from Contact where email = null';
        return Database.getQueryLocator(query);        
    }
    global void execute(Database.BatchableContext BC, List<Contact> contactList) {
        for(Contact con: contactList) {
            con.email = 'r@gmail.com';
        }        
        update contactList;
    }
    global void finish(Database.BatchableContext BC) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[]{'r@gmail.com'};
        mail.setToAddresses(toAddress);
        mail.setSubject('Batch Proces');
        mail.setPlainTextBody('Batch Process has completed');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }          
}