public with sharing class email {

    public String to{get;set;}
    public String subject{get;set;}
    public String body{get;set;}
    
    public PageReference sendEmail() {
    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {to});
        mail.setReplyTo('r.z.kuma@accenture.com');
        mail.setSenderDisplayName('Rahul Kumar');
        mail.setSubject('Testing Email');
        mail.setPlainTextBody('Email sent');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        return null;
    }
}