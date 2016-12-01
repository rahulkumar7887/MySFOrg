@isTest
private class SalaryHelper1Test{
    static List<Salary__c> s1List;
     @testsetup
    static void prepareData(){
        Salary__c s1 = new Salary__c(actual_pay__c = 3000);
        Salary__c s2 = new Salary__c(actual_pay__c = 5000);
        Salary__c s3 = new Salary__c(actual_pay__c = 7000);
        s1List = new List<Salary__c>{s1,s2,s3};
    }
    static testmethod void calcHRA_Positive(){
        /*Salary__c s1 = new Salary__c(actual_pay__c = 3000);
        Salary__c s2 = new Salary__c(actual_pay__c = 6000);
        Salary__c s3 = new Salary__c(actual_pay__c = 8000);
        List<Salary__c> sList = new List<Salary__c>{s1,s2,s3};*/ //no need for this data for data using from static resource
        prepareData();
        Test.startTest();
            try{
                //insert sList;//no need for this data for data using from static resource
                //List<Salary__c> sList = Test.loadData(Salary__c.sObjectType,'salary');to get data from static resource
                Map<ID,Salary__c> sMap = new Map<Id,Salary__c>(s1List);
                List<Salary__c> loadData = [select actual_pay__c,hra__c from Salary__c where id in:sMap.keySet()];
                for(Salary__c s: loadData){
                    system.assertEquals(s.hra__c,s.actual_pay__c*0.35);
                }
             
            }catch(System.Exception e){
                system.debug('Name of exception is :'+e.getTypeNAme());
                system.debug('Name of error is :'+e.getMessage());
                
            }
        Test.stopTest();       
    }
    
    static testmethod void exceptionTest(){
        Salary__c s1 = new Salary__c(actual_pay__c = 3000);
        Salary__c s2 = new Salary__c(actual_pay__c = 6000);
        Salary__c s3 = new Salary__c(actual_pay__c = 8000);
        Salary__c s4 = new Salary__c(actual_pay__c = 0);
        List<Salary__c> sList = new List<Salary__c>{s1,s2,s3,s4};
        Test.startTest();
            try{
                //List<Salary__c> sList = Test.loadData(Salary__c.sObjectType,'salary');
                insert sList;
                Map<ID,Salary__c> sMap = new Map<Id,Salary__c>(sList);
                List<Salary__c> loadData = [select actual_pay__c,hra__c from Salary__c where id in:sMap.keySet()];
                for(Salary__c s: loadData){
                    system.assertEquals(s.hra__c,s.actual_pay__c*0.35);
                }
            }//catch(System.DMLException de){
                catch(SalaryException  se){
               //SalaryException se = new SalaryException(); 
               system.debug(se.displayError());
                
            }
        Test.stopTest();       
    }
}