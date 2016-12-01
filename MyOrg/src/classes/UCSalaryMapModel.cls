public abstract class UCSalaryMapModel implements UCSalaryMap{
    public void display(Position__c p){
        system.debug('min pay and max pay'+ p.min_pay__c+ ' '+p.max_pay__c);
    }
    
    public abstract void assignSalary(Position__c p);
}