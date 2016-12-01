public class CaseDiscUpdate {
    public void updateDisc(List<Account> aList) {
        List<Account> lAcc = new List<Account>();
        //for(Account a: aList) {
            //lAcc.add(a.id);
        //}
        Set<Id> sAcc = new Set<Id>();
        for(SObject SObj : aList) {
            sAcc.add(SObj.getSobject('Account').id);
        }
        system.debug(sAcc);
        
        
    }
}