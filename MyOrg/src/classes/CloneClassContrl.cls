public class CloneClassContrl {
	public String selectedIds;
	public List<String> lstSelectedIds;
    public List<Class__c> lstClass {get;set;}
    public List<Class__c> lstClassToClone;
    public Class__c classRecord;
    
    public CloneClassContrl(ApexPages.StandardController controller) {
    
    }
    
    public CloneClassContrl(ApexPages.StandardSetController controller) {
		selectedIds = ApexPages.currentPage().getParameters().get('Id');
		lstSelectedIds = selectedIds.split(',');
		System.debug('##lstSelectedIds##' + lstSelectedIds);
		lstClass = [Select Id,Name,Available__c from Class__c where Id IN :lstSelectedIds];
        
        classRecord = (Class__c)controller.getRecord();
        System.debug('##classRecord##' + classRecord);
    }
	
    public void cloneClass(){
        lstClassToClone = new List<Class__c>();
        if(!lstClass.isEmpty()){
            //Clonning Logic
        	for(Class__c cls: lstClass){
            	Class__c cRecord = new Class__c();
                cRecord = cls.clone(false,false,false,false); 
                lstClassToClone.add(cRecord);
        	}    
        }
        if(!lstClassToClone.isEmpty()){
            System.debug('##lstClassToClone##' + lstClassToClone);
            insert lstClassToClone;
        }        
    }
}