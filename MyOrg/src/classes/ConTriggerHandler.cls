public class ConTriggerHandler {

    @InvocableMethod 
    public static void handleAfterInsertEvent(List<Con__c> cList) {
        Set<Id> aId = new Set<Id>();
        for(Con__c c: cList) {
            aId.add(c.Acc__c);
        }
        
        Map<Id, Acc__c> AccMap = new Map<Id, Acc__c>([select Id,Total_no_of_Emp__c from Acc__c where Id in : aId]);
        for(Con__c a: cList) {
            Acc__c acc = AccMap.get(a.Acc__c);
            acc.Total_no_of_Emp__c = acc.Total_no_of_Emp__c + a.No_of_Emp__c;    
        }
        update AccMap.values();         
    }
}