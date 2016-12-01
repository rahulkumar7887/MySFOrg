public class OrderTriggerHandler {
    
    public static void dontClone(List<Order> lstOrder){
        for (Order objOrder: lstOrder){    
            objOrder.PoNumber = null;    
        }
    }
    
    public static void attachPDF(Map<Id,Order> mapOldOrders,List<Order> lstNewOrders){
        
        List<Id> listImpactedOrders = new List<Id>();
        for(Order newOrd : lstNewOrders) {
            if((newOrd.Status != mapOldOrders.get(newOrd.Id).Status) && (newOrd.Status == '')) {
                   listImpactedOrders.add(newOrd.Id);
            }
        }
        
        if(!listImpactedOrders.isEmpty()){
            generateAttachPDF(listImpactedOrders);
        }
    }   
    
    @future(callout=true)
    public static void generateAttachPDF(List<Id> listImpactedOrders){
        for(Id ordId : listImpactedOrders){
            PageReference pageRef = Page.OrderConfirmationEmail;//new PageReference('Page.OrderConfirmationEmail');
            pageRef.getParameters().put('Id', ordId);
            
            Attachment attach = new Attachment();
            Datetime currentDate = Datetime.now();
            String dateOutput = currentDate.format('yyyyddMMHHmm');
            attach.Name = 'Order_Confirmation_Email_' + dateOutput;// 201607221315';
            attach.ParentId = ordId;
            attach.ContentType = 'application/pdf';
            attach.Body = (Test.IsRunningTest() ? Blob.valueOf('UNIT.TEST') : pageRef.getContentAsPDF());
            Database.insert(attach); 
         }         
    }
    
    public static void sendEmailWithAttachment(Map<Id,Order> mapOldOrders, Map<Id,Order> mapNewOrders){
        //Set to hold Order Id
        Set<Id> setOrderId = new Set<Id>();
        for(Id ordId: mapNewOrders.keySet()){
            //If Order's Approval Counter has changed then add the Orders Id to set
            //if(mapNewOrders.get(ordId).Approval_Counter__c != mapOldOrders.get(ordID).Approval_Counter__c){
                //setOrderId.add(ordId);  
            //}           
        }
        //If the setOrderId is not empty call the future method to send the mail
        if(!setOrderId.isEmpty()){
            sendEmailHelperMethod(setOrderId);
        }
    } 
    
    @future
    public static void sendEmailHelperMethod(Set<Id> orderId){
        List<ProcessInstance> lstProcessInstance = [SELECT Id, TargetObjectId, Status,  
                                                (SELECT Id, ActorId, ProcessInstanceId FROM Workitems)
                                                FROM ProcessInstance p WHERE p.TargetObjectId IN :orderId];
        System.debug('#lstProcessInstance' + lstProcessInstance);
        if(!lstProcessInstance.isEmpty()){
            for(ProcessInstance processInstance : lstProcessInstance){
                List<ProcessInstanceWorkitem> lstWorkItem = processInstance.Workitems;
                System.debug('#lstWorkItem' + lstWorkItem);
                if(!lstWorkItem.isEmpty()){
                    //get user's id from workitem and send the email 
                    //List<User> user = [Select Id From User Where Id =: lstWorkItem[0].ActorId Limit 1];
                    //System.debug('#user' + user[0].Id);
                    
                    //sendEmail(processInstance.TargetObjectId);//, user[0].Id);
                }
            }
        }
    }
    
    public static void sendEmail(Id ordId, Id uId){
        //Get the Email Template 
        EmailTemplate emailTemplate = [Select Id, Name From EmailTemplate Where Name = 'CRM - Return Order Email Template'];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(uId);
        mail.setTemplateID(emailTemplate.Id);
        mail.setSaveAsActivity(false);
        
        //Get the userId of the Email Service User from Custom Setting
        //CRM_Default_Configuration__c defaultConfiguration = CRM_Default_Configuration__c.getOrgDefaults();
        //Id emailUserId = defaultConfiguration.Email_Service_User_Id__c;
        Id emailUserId;
        //System.debug('emailUserId' + emailUserId);
        
        //Get the Attachments on the Order
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        for (Attachment attachment : [select Name, Body, ContentType From Attachment Where ParentId = :ordId AND CreatedById = :emailUserId AND ContentType = 'application/pdf']){  
            Messaging.Emailfileattachment emailFileAttachment = new Messaging.Emailfileattachment();
            emailFileAttachment.setFileName(attachment.Name);
            emailFileAttachment.setBody(attachment.Body);
            fileAttachments.add(emailFileAttachment);
        }
        
        //Add the Attachment to the mail
        mail.setFileAttachments(fileAttachments);
        
        //Send the mail
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }    
}