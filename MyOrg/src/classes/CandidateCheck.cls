global class CandidateCheck{
    webservice static String checkCandidate(String cemail){
        Candidate__c c = [select first_name__c, last_name__c, city__c from Candidate__c where email__c=:cemail Limit 1];
        if(c!= null){
            return c.first_name__c+' ' +c.last_name__c+' ' +c.city__c;
        }
        else{
            return 'Candidate not found with the email';
        }
    }
}