public with sharing class testController {
    String id;
    public String currentRecordId {set;get;}
    
    public testController(ApexPages.StandardController controller) {
        id = controller.getRecord().Id;
    }
    
    public PageReference saveAndReject() {
        Account acc = new Account();
        acc.name = 'testAcc';
        insert acc; 
        currentRecordId = acc.Id;
        system.debug('!!' + currentRecordId  );
        PageReference requestPage = new pagereference('/apex/thanks?id=' + currentRecordId  );
        requestPage.setRedirect(true);
        return requestPage;
    }
}