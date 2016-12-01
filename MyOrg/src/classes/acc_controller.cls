public with sharing class acc_controller {

    public  List<Account> accList{get;set;}
    public  List<AccWrapper> accWrapList{get;set;}
    public  List<AccWrapper> accWrapList2{get;set;}
    public  List<AccWrapper> accWrapList3{get;set;}
    
    //public Integer cust_limit{get;set;}
    public  Integer cust_offset{get;set;}
    public  Integer cust_fixed_offset{get;set;}
    public  Boolean showFinalResult{get;set;}

    public Boolean hasPrevious {get;set;}
    public Boolean hasNext {get;set;}
    
    public acc_controller(ApexPages.StandardController controller){
        //cust_limit=1;
        hasNext = true;
        hasPrevious = false; 
        showFinalResult=false;
        cust_fixed_offset = 10;
        cust_offset = 0;
        accList = new List<Account>();
        accWrapList = new List<AccWrapper>();
        accWrapList2 = new List<AccWrapper>();
        
        accList = [select id,name from account limit 100];
        
        Integer count = 0;
        for(Account accObj :accList){
            accWrapList.add(new AccWrapper(accObj));
            if(count < cust_fixed_offset){
                accWrapList2.add(new AccWrapper(accObj));
                count++;
            }
        }
    }
        
    public void first(){}
    
    public void last(){}
        
    public void next(){
        hasPrevious = true;
        
        accWrapList2 = new List<AccWrapper>();
        
        cust_offset += cust_fixed_offset; 
        if(cust_offset > accWrapList.size()-1){
            cust_offset = accWrapList.size()-1;            
        }
        
        Integer counter = 0;
        for(Integer i = cust_offset; i < accWrapList.size(); i++){
            if(counter < cust_fixed_offset){
                 accWrapList2.add(accWrapList[i]);
                 counter++;
            }
            else{
            	break;
            }            
        }
    }
        
    public void previous(){    
    	accWrapList2 = new List<AccWrapper>();
        cust_offset -= cust_fixed_offset;
        
        if(cust_offset < 1){
            cust_offset = 0;            
        }
        
        Integer counter=0;
        for(Integer i = cust_offset; i < accWrapList.size(); i++){
            if(counter < cust_fixed_offset){
            	accWrapList2.add(accWrapList[i]);
             	counter++;
            }
            else{
            	break;
            }            
        }    
    }
    
    public void Process(){         
    	accWrapList3 = new List<AccWrapper>();
        for(AccWrapper accWrapObj1 :accWrapList){
        	if(accWrapObj1.flag){
            	accWrapList3.add(accWrapObj1);
            }
        }
        showFinalResult=true;
    }
    
    public void saveList(){
    	for(AccWrapper accWrapObj1 :accWrapList){
        	for(AccWrapper accWrapObj2 :accWrapList2){
            	if(accWrapObj2.acc.Id == accWrapObj1.acc.Id){
                   accWrapObj1.flag = accWrapObj2.flag; 
                }
            }
        }
    }
    
    public Class AccWrapper {
    	public Account acc {get;set;}
        public Boolean flag {get;set;}
        
        public AccWrapper(Account acc){
            this.acc = acc;
            this.flag = false;
        }
    }
}