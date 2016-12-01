public class CaseTriggerHandler {

    public void handleAfterUpdateEvent(List<Case> cList) {
        Set<Id> conId = new Set<Id>();
        for(Case c: cList) {
            conId.add(c.ContactId);
        }
        //suppose all the contacts are different 2 are same then it will become 1 because it is SET..
        Map<Id, Contact> ConMap = new Map<Id, Contact>([select Id,Avg_Cases__c from Contact where Id in : conId]);
        Integer Count = 0;
        Integer Sum = 0;
        List<Case> CaseID = new List<Case>([select ID,Technical_difficulty_level__c from Case where ContactID IN: conID]);
        for(Case c: CaseID) {
            Count++;
            Sum = Sum + Integer.Valueof(c.Technical_difficulty_level__c);
        }
        for(Case c: cList) {
            Contact con = ConMap.get(c.ContactId);
            con.Avg_Cases__c = Sum/Count;    
        }
        update ConMap.values();         
    }
    
    public static void updateNumberOfCases(List<Case> cList){
        Set<Id> aId = new Set<Id>();
        Set<Id> cId = new Set<Id>();
        for(Case c: cList){
            aId.add(c.accountId);
            cId.add(c.contactId);
        }
        Map<Id, Account> aMap = new Map<Id,Account>([Select Id,Number_of_Cases__c from Account where Id IN :aID]);
        Map<Id, Contact> cMap = new Map<Id,Contact>([Select Id,Number_of_Cases__c from Contact where Id IN :cID]);
        for(Case c: cList){
            Account acc = aMap.get(c.accountId);
            if(acc != NULL){
                acc.Number_of_Cases__c++;
            }
            Contact con = cMap.get(c.contactId);
            if(con != NULL){
                con.Number_of_Cases__c ++;
            }
        }
        update aMap.values();
        update cMap.values();
    }
    
    public static void deleteNumberOfCases(List<Case> cList){
        Set<Id> aId = new Set<Id>();
        Set<Id> cId = new Set<Id>();
        for(Case c: cList){
            aId.add(c.accountId);
            cId.add(c.contactId);
        }
        Map<Id, Account> aMap = new Map<Id,Account>([Select Id,Number_of_Cases__c from Account where Id IN :aID]);
        Map<Id, Contact> cMap = new Map<Id,Contact>([Select Id,Number_of_Cases__c from Contact where Id IN :cID]);
        
        for(Case c: cList){
            Account acc = aMap.get(c.accountId);
            Contact con = cMap.get(c.contactId);
            if(acc != NULL){
                acc.Number_of_Cases__c--;
            }
            if(con != NULL){
                con.Number_of_Cases__c--;
            }            
        }
        update aMap.values();
        update cMap.values();
    }
    
    public void handleBeforeUpdateEvent(Map<Id,Case> cOldMap, Map<Id, Case> cNewMap){
        List<Contact> conList;
        for(Id c: cNewMap.Keyset()){
            if(cNewMap.get(c).contactId != cOldMap.get(c).contactId && cOldMap.get(c).contactId != NULL && cNewMap.get(c).contactId != NUll){
                cNewMap.get(c).contact.Number_of_Cases__c ++;
            }
            else {
                Set<Id> cId = new Set<Id>();
                cId.add(cOldMap.get(c).contactId);
                conList = [Select Id,Number_of_Cases__c from Contact where Id IN :cId];
                System.debug('@#@#@#@# conList size: ' + conList.size());
                
                if(conList != Null) {
                    for(Contact cList: conList){
                        System.debug('#@#@#@ cList.Number_of_Cases__c: ' +  cList.Number_of_Cases__c);
                        cList.Number_of_Cases__c --;
                        System.debug('@#@#@#@ cList.Number_of_Cases__c: ' + cList.Number_of_Cases__c);
                    }
                }
            }
        }
        
        //update cNewMap.values();
        if(conList != Null) {
            update conList;
        }
    }    
}