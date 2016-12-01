public class TestObjectHandler {
    /*
    public void makeFieldUnique(List<Test_Object__c> toList){
        //List of all the records already in the system
        List<Test_Object__c> listTO = [Select Id, Unique_Field__c from Test_Object__c];
        //Set to store the values
        Set<String> sSet = new Set<String>();
        //Adding the values to set
        for(Test_Object__c o: listTO){
            sSet.add(o.Unique_Field__c);
        }
        //Logic to test uniqueness 
        for(Test_Object__c o: toList){
            if(sSet.contains(o.Unique_Field__c)){
                o.addError('Duplicate Field');
            } 
        }        
    }*/
    public static void meth1(List<Test_Object__c> toNewList){
        System.debug('#' + toNewList);
    }
    public static void meth2(List<Test_Object__c> toOldList){
        System.debug('##' + toOldList);
    }    
}