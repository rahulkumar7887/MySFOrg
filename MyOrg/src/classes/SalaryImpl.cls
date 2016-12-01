public class SalaryImpl extends SalaryHelper{
    public void checkPosition(Position__c p){
        if(p.type__c != null){
            assignSalary(p);
        }
    }
}