public virtual class SalaryHelper extends UCSalaryMapModel{
    public override void assignSalary(Position__c p){
        if(p.type__c =='Full Time'){
            p.min_pay__c = 10000;
            p.max_pay__c = 15000;
        }
        if(p.type__c == 'Part Time'){
             p.min_pay__c = 8000;
             p.max_pay__c = 12000;
        }
         if(p.type__c == 'Temp'){
             p.min_pay__c = 5000;
             p.max_pay__c = 7000;
        }
    }
}