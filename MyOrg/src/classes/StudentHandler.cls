public class StudentHandler {
    public static void validateEmail(List<Student__c> sList) {
        //List<EmailDomain__c> eList = [select Name from EmailDomain__c];
        set<String> strlist = new set<String>();
        //for(EmailDomain__c e: eList) {
        for(EmailDomain__c e: [select Name from EmailDomain__c]) {
        
            strlist.add(e.name); 
        }  
        for(Student__c s: sList) {
            String semail = s.Email_Id__c.substringbetween('@','.');         
            if(!(strlist.contains(semail))){
                s.addError('Check Email Domain'); 
            }             
        }        
    }
    
    public static void classStrength(List<Student__c> sList) {
        for(Student__c s: sList) {
            if(s.Class__r.Available__c <= 0) {
                s.addError('Not Available');
            }
                      
        }   
    }
    
    public static void duplicateStudentCheck(List<Student__c> stuList){
        Map<String, Student__c> mapExistingStudent = new Map<String, Student__c>();
        List<Student__c> lstStudent = [Select Id, Email_Id__c From Student__c];
        for(Student__c stu: lstStudent){
            mapExistingStudent.put(stu.Email_Id__c, stu);
        }
        List<Student__c> studentsToInsert = new List<Student__c>();
        List<Student__c> studentsExisting = new List<Student__c>();
        for(Student__c stu1: stuList){
            if(mapExistingStudent.containsKey(stu1.Email_Id__c)){
                //stu1.Email_Id__c.addError('Duplicate Student');
                //make a error list and add this and show it finally
                studentsExisting.add(stu1);
            }
            else{
                studentsToInsert.add(stu1);
            }
        }
        System.debug('studentsToInsert' + studentsToInsert);
        System.debug('studentsExisting' + studentsExisting);
        //insert studentsToInsert;
    }
}