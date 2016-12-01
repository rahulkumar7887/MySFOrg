public with sharing class studController {

    Student__c s;
    PageReference pr;
    
    public studController(ApexPages.StandardController controller) {
        s = (Student__c)controller.getRecord();
    }
    public PageReference showNext(){
        pr = new PageReference('/apex/NavigatingMultiplePage2');
        pr.getParameters().put('Name', s.Name);
        pr.getParameters().put('Class', s.class__c);
        pr.setRedirect(false);
        return pr;
    }
    public PageReference saveRecord() {
        Student__c stu = new Student__c();
       
        stu.name = pr.getParameters().get('Name');
        stu.class__c = pr.getParameters().get('Class');
        
        //System.debug('#####' + pr.getParameters().get('Name'));
        
        stu.DOB__c = stu.DOB__c;
        
        insert(stu);
        
        PageReference pr1 = new PageReference('/apex/testPage');
        pr.setRedirect(true);
        return pr1;
    }    
}