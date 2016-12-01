trigger StudentTrigger on Student__c (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            //StudentHandler.validateEmail(Trigger.New);
			StudentHandler.classStrength(Trigger.New); 
            StudentHandler.duplicateStudentCheck(Trigger.New);
        }
    }
}