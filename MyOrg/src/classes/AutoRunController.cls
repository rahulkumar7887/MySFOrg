public class AutoRunController {
    
    private final ApexPages.StandardController c;
    public AutoRunController(ApexPages.StandardController controller) {
        c = controller;
    }
    
    //code will invoke on page load
    public PageReference autoRun(){
        try{
            List<Position__c> l = [Select Id, Priority__c from Position__c where Id !=: c.getId()];
            for(Position__c i:l)
                i.Priority__c = 'Low';
            update l;
            Position__c p = (Position__c)c.getRecord();
            p.Priority__c = 'Critical';
            update p;
        } catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
        return c.View().setRedirect(true);
    }    
}