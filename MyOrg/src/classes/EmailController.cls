public with sharing class EmailController {
    public String toAddr{get;set;}
    public String sub{get;set;}
    public String ebody{get;set;}
    public String eres{get;set;}
    
    public void checkEmailSend(){
        Messaging.SingleEmailMessage sm = new Messaging.SingleEmailMessage();
        sm.setToAddresses(new List<String>{toAddr});
        sm.setSubject(sub);
        sm.setPlainTextBody(ebody);
        List<Messaging.SendEmailResult> sList = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{sm});
        for(Messaging.SendEmailResult sr: sList){
            if(sr.isSuccess()){
                eres='Message Processeed Successfully';
            }
            else{
                Messaging.SendEmailError er = sr.getErrors()[0];
                eres = er.getMessage();
            }
        }
    }
}