global with sharing class Book_ApproveRejectCtrl {
      
  	public static String bookId;
     
    public Book_ApproveRejectCtrl(ApexPages.Standardcontroller stdCon) {
        bookId = stdCon.getId();
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
    }
    
    @RemoteAction 
    global static Book__c[] getBooks(Id bId){
        Book__c[] books = [select Id, Name From Book__c where id =: bId Limit 1];
        System.debug('##books ' + books);
        return books;
    }
        
    @RemoteAction 
    global static void processApprove(Id bId, String actionToPerform){
        System.debug('##actionToPerform' + actionToPerform);
        //get the Approval Process wich is currently in process using bId.
        ProcessInstance[] processInstanceList = [SELECT Id, TargetObjectId, Status, (SELECT Id FROM Workitems) From ProcessInstance p where p.TargetObjectId =: bId And Status = 'Pending'];
        //List to hold the currently executing Approval Process
        List<Id> workItemIds = new List<Id>();
        //Iterate through and get the id's.
        for(ProcessInstance processInstance : processInstanceList){
        	for (List<ProcessInstanceWorkitem> processInstanceWorkItemsList: processInstance.Workitems) {
            	for (ProcessInstanceWorkitem processInstanceWorkItems: processInstanceWorkItemsList ) {
                      workItemIds.add(processInstanceWorkItems.id);
            	}
          	}
        }
        //Logic to Approve/Reject
        Approval.ProcessWorkItemRequest procWorkItemReq = new Approval.ProcessWorkitemRequest();
        procWorkItemReq.setWorkitemId(workItemIds.get(0));
        if(actionToPerform.equalsIgnoreCase('Approve'))
        	procWorkItemReq.setAction('Approve'); 
        else
        	procWorkItemReq.setAction('Reject');
        Approval.ProcessResult result =  Approval.process(procWorkItemReq);
    }
    
    public void submitForApproval(Id bId){
    	if (String.isNotBlank(bId)){
            try{                           
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(bId);
                Approval.ProcessResult result = Approval.process(req);
            }catch(Exception e){
                system.debug(e.getMessage());
            }   
        }
    }
    
    @RemoteAction
    global static List<ProcessInstanceHistory> generateData(Id assortmentId){
		List<ProcessInstanceHistory> lstProcessInstHistory = new List<ProcessInstanceHistory>();    
        for(ProcessInstance processInstance: getProcessHistory(assortmentId).values()){
			for(ProcessInstanceHistory processInstanceHistoryWorkItem: processInstance.StepsAndWorkitems){
                lstProcessInstHistory.add(processInstanceHistoryWorkItem);
            }            
        }
        return lstProcessInstHistory;
    }
    
    @RemoteAction
    global static Map<Id,ProcessInstance> getProcessHistory(Id assortmentId){  
       return new Map<Id,ProcessInstance>([SELECT Id, 
				(SELECT ID, ProcessNodeId,StepStatus,Comments,TargetObjectId,ActorId,CreatedById,IsDeleted,IsPending,
				OriginalActorId,ProcessInstanceId,RemindersSent,CreatedDate, Actor.Name, OriginalActor.Name , 
				ProcessNode.Name FROM StepsAndWorkitems order by CreatedDate DESC) 
			FROM ProcessInstance where TargetObjectId =:assortmentId order by CreatedDate DESC]);
    } 
}