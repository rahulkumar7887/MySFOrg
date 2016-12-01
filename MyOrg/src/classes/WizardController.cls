public with sharing class WizardController {
    
    Candidate__c c;
    ApexPages.StandardController sc;
    public WizardController(ApexPages.StandardController controller) {
        c = (Candidate__c)controller.getRecord();
    }
    public pageReference nextPage(){
        if(c.first_name__c ==null || c.last_name__c ==null ){
            ApexPages.Message ms = new ApexPages.Message(ApexPages.severity.Error,'Please provide values to continue..');
            ApexPages.addMessage(ms);
            return null;
            //return null; we can use null instead of sc.view()
        }
        else{
            PageReference pr = new PageReference('/apex/candidiatePage2');
            pr.getParameters().put('FNAME',c.first_name__c);
            pr.getParameters().put('LNAME',c.last_name__c);
            pr.setRedirect(true);
            return pr;
        }
    }
    
    public PageReference createCandidate(){
        if(c.city__c ==null || c.state_Province__c ==null){
            ApexPages.Message ms = new ApexPages.Message(ApexPages.severity.ERROR,'Please provide values to continue..');
            ApexPages.addMessage(ms);
            return null;
        }
        else{
            c.first_name__c = ApexPages.currentPage().getParameters().get('FNAME');
            c.last_name__c = ApexPages.currentPage().getParameters().get('LNAME');
            Database.insert(c);
            
            PageReference pr = new PageReference('/'+c.id);
            return pr;
        }
       
            
    }

}