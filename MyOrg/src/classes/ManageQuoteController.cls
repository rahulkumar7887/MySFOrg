public with sharing class ManageQuoteController {
    public Opportunity opportunityRef {get; set;}
    public Boolean quoteCreationError {get; set;}
    public Boolean quoteCreated {get; set;}
    public String errorMessage {get; set;}
    public String quoteUrl {get; set;}
    
    public ManageQuoteController() {
        quoteCreated = false;
        quoteCreationError = false;
        Id opptyId = ApexPages.currentPage().getParameters().get('opportunityId');
        try{
        	opportunityRef = [select Id, Name from Opportunity where Id = :opptyId];
        }
        catch (System.QueryException e) {
          System.debug('caught ya!');
        }
    }
   
    public PageReference goback() {
        return new Apexpages.Standardcontroller(opportunityRef).view();
    }
   
    public PageReference createQuote() {
        Opportunity oppty = [select Id, Name, StageName, CloseDate, Owner.Name, AccountId, Account.Name,
            Account.Sic, Account.Industry, Account.BillingStreet, Account.BillingCity, Account.BillingState,
            Account.BillingPostalCode, Account.BillingCountry from Opportunity where Id = :opportunityRef.Id];
        
        OpportunityContactRole ocr = [select ContactId, Contact.FirstName, Contact.LastName, Contact.EMail, Contact.Phone, Contact.Fax
            from OpportunityContactRole where opportunityId = :opportunityRef.Id and IsPrimary = true];
        /*
        List<QuoteResponse> response = QuoteServiceDelegate.createQuote(oppty, ocr.ContactId);
        if (response.stausCode != 200) {
            quoteCreationError = true;
            errorMessage = response.message;
        } else {
            quoteCreated = true;
            quoteUrl = response.quoteUrl;
        }*/
        return null;
    }
}