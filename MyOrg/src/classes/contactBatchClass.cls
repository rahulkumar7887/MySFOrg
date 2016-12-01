global class contactBatchClass implements Database.Batchable<sobject> {

String email = 'j.pulinholi.raghavan@accenture.com'; 
String query;

public contactBatchClass (String query) {
this.query = query; 
}

global Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(query); 
}

global void execute(Database.BatchableContext BC, list<sobject> obj){
    system.debug('Rahul' + obj);
    contactTiggerHandler handler = new contactTiggerHandler ();
    handler.handleAfterInsertEvent(obj);
}

global void finish(Database.BatchableContext BC){
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new String[] {email});
    mail.setReplyTo('r.z.kuma@accenture.com');
    mail.setSenderDisplayName('Rahul Kumar');
    mail.setSubject('Batch Process Completed');
    mail.setPlainTextBody('Accoutn Batch Class has completed');
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}