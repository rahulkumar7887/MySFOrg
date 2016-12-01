public with sharing class forgotPasswordController {

    public String email{get;set;}
    
    public PageReference forgotPassword() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {email});
        mail.setReplyTo('r.z.kuma@accenture.com');
        mail.setSenderDisplayName('Rahul Kumar');
        mail.setSubject('Testing Email');
        mail.setPlainTextBody('Email sent');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return null;
    }
}