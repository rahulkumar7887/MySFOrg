trigger SalaryTrigger on Salary__c (before insert,before update) {
    SalaryHelper1.calHRA(Trigger.new);
}