public class ClassHandler {
    public void preventClassDeletion(List<Class__c> cList)
    {
        for(Class__c c: cList){
            if(c.Available__c != 2) {
                c.addError('Cannot delete this Class as students are prevent, Please delete Students first');
            }
        }
    }
}