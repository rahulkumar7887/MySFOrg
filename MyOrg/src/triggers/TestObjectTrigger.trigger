trigger TestObjectTrigger on Test_Object__c (before insert, before update) {
    /*
    TestObjectHandler obj = new TestObjectHandler();
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            obj.makeFieldUnique(Trigger.New);
            //obj.checkDuplicates(Trigger.New);
        }
    }
    */
    if(Trigger.isBefore){
        if(Trigger.isInsert){
        	TestObjectHandler.meth1(Trigger.New); 
        	//Trigger.Old is NULL
            //TestObjectHandler.meth2(Trigger.Old); 
        }
        if(Trigger.isUpdate){
        	//TestObjectHandler.meth1(Trigger.New);
        	//TestObjectHandler.meth2(Trigger.Old);
        }
        if(Trigger.isInsert || Trigger.isUpdate){
        	
        }
        if(Trigger.isDelete){
        	//Trigger.New is NULL
            //TestObjectHandler.meth1(Trigger.New);
        	//TestObjectHandler.meth2(Trigger.Old);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            TestObjectHandler.meth1(Trigger.New); 
        	TestObjectHandler.meth2(Trigger.Old);
        }
        
        if(Trigger.isUpdate){
            //TestObjectHandler.meth1(Trigger.New); 
        	//TestObjectHandler.meth2(Trigger.Old);
        }
        
        if(Trigger.isInsert || Trigger.isUpdate){
        }
        
        if(Trigger.isDelete){
            //Trigger.New is NULL
            //TestObjectHandler.meth1(Trigger.New); 
        	//TestObjectHandler.meth2(Trigger.Old);
        }
    }
}