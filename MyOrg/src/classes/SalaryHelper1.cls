public with sharing class SalaryHelper1{
    public static void calHRA(List<Salary__c> sList){
            
            for(Salary__c s: sList){
                if(s.actual_pay__c == 0){
                    throw new SalaryException('Actual pay is 0',s);
                }
                else
                s.hra__c = s.actual_pay__c* 0.35;
            }
        
    }
}