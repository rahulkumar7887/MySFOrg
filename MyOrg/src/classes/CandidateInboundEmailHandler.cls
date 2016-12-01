global class CandidateInboundEmailHandler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope env){
        
        Candidate__c can = new Candidate__c();
        can.First_Name__c = 'Email Candidate';
        can.Email__c = email.fromAddress;
        
        Database.insert(can, false);
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        return result;
    }
}