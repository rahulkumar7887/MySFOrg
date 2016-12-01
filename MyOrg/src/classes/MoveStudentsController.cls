public with sharing class MoveStudentsController {

    public List<selectOption> ClassNameOptions {
    get {
            List<selectOption> className = new List<selectOption>();
            className.add(new selectOption('Value', 'Select')); // 'Value', 'Label'
            for (Class__c c : [select Name from Class__c])
                 className.add(new selectOption(c.Name,c.Name)); // one for name which is displayed and another for value
            return className;
    }
    private set;}

    public MoveStudentsController(ApexPages.StandardController controller) {

    }
    
    public List<sStudent> studentList {set; get;}
    
    public class sStudent {
        public Student__C stu {get; set;}
        public Boolean selected {get; set;}
        
        public sStudent(Student__c s) {
             stu = s;
             selected = false;
        }
    }
    
    public List<sStudent> getStudents() {
        if(studentList == null) {
            studentList = new List<sStudent>();
            for(Student__c s: [select Id, Name from Student__c]) {
                studentList.add(new sStudent(s));
            }
        }
        return studentList;
    }
    

    public PageReference MoveSelectedStudents() {
    
        List<Student__c> selectedStudents = new List<Student__c>();
        for(sStudent sStu: getStudents()) {
              if(sStu.selected == true) {
                  selectedStudents.add(sStu.stu);
              }
        }
        
        
        System.debug('These are the selected Contacts...');
    for(Student__c stu: selectedStudents) {
        system.debug('Yadavansh' + stu);
    }
    
    return null;
    }
    
}