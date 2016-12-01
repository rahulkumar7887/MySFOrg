global class AutoAllocateCtrl{
    public Teacher__c teacher{get;set;}
    public Teacher__c[] teachers{get;set;}
    
    //No need in case of 'recordSetVar'/'StandardSetController'
    public AutoAllocateCtrl(ApexPages.StandardController controller) {

    }
    
    //used in 'recordSetVar'
    public AutoAllocateCtrl(ApexPages.StandardSetController setController) {
        String teacherId = ApexPages.currentPage().getParameters().get('Id');
        
        if(teacherId != null) {
            this.teacher = [Select Id,Name From Teacher__c where Id =: teacherId];
        }
        else{
            this.teachers = (Teacher__c [])setController.getSelected();
        }
    }
    
    @RemoteAction
    global static TeacherError[] createStuTeachDetails(String[] teacherIds) {
        Map<Id, TeacherError> mapTeacherError = new Map<Id, TeacherError>();
        List<Student__c> lstStudent = new List<Student__c>();
        
        List<Teacher__c> lstTeacher = [Select Id, Name, Class__c, Class__r.Name From Teacher__c where Id IN :teacherIds];
        lstStudent = createStudent(lstTeacher);
        
        if(!lstStudent.isEmpty() && lstStudent.size() > 0){
        	Database.UpsertResult[] result = Database.Upsert(lstStudent, Student__c.UniqueKey__c, false);
            	for(Integer i=0; i < result.size(); i++ ){
                    if(!result[i].isSuccess()){
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        System.debug('failedDML--->'+failedDML);
                        
                        Teacher__c failedTeach = lstTeacher[i];
                        mapTeacherError.put(failedTeach.Id, new TeacherError(failedTeach, failedDML));
                    }
             	}
        }        
        return mapTeacherError.values();
    }
    
    public static List<Student__c> createStudent(List<Teacher__c> lstTeacher){
        List<Student__c> lstStudent = new List<Student__c>();
        Student__c student;
        for(Teacher__c teach: lstTeacher){
        	student = new Student__c();
            student.Class__c = teach.Class__c;
            student.Name = teach.Class__r.Name + ' - ' + teach.Name;
            student.Teacher__c = teach.Id;
            student.UniqueKey__c = teach.Class__c + ' - ' + teach.Id;
            lstStudent.add(student);
        }        
        return lstStudent;
    }
    
    global class TeacherError{
        global String id;
        global String name;
        global String error;
        
        global TeacherError(Teacher__c teach, String errMsg){
          this.id = teach.Id;
          this.name = teach.Name;
          this.error = errMsg;
        }
    } 
}