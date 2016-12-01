public with Sharing class GenerateOrderFromDealController{
    private final Opportunity opt;
    public Map<String, Object> params;
    public static Opportunity dealRecord {get;set;}
    
    public GenerateOrderFromDealController(ApexPages.StandardController controller) {
        this.opt= (Opportunity)controller.getRecord();
        
        List<Opportunity> lstOpportunity = [SELECT id, name FROM Opportunity WHERE id = :controller.getId()];
        
        if (!lstOpportunity.isEmpty()) {
            dealRecord = lstOpportunity[0];
        }
        
        params = new Map<String, Object>();
    }
    
    /**
    *  Description-The method is used to pass parameter to Flow and instantiate the page to which the flow should redirect
    *  @name-startFlow
    *  @param-None
    *  @return-The return parameter redirects to the new order edit layout
    *  @throws exception-An unhandled fault has occurred while processing the flow. Please contact your system administrator for more information.
    */
    public PageReference startFlow(){
        
        PageReference orderPage;
        try{
            if(dealRecord.Account.Status__c == AppConstants.ACCOUNT_STATUS_BLOCKED){
                throw new GenerateOrderFromDealControllerException(Label.Restrict_Order_Generation_for_Blocked_Account);
            }
            
            if(dealRecord.stageName != AppConstants.OPPORTUNITY_STAGE_CLOSED_LOST){
                throw new GenerateOrderFromDealControllerException(Label.Restrict_Order_Generation_on_Stage);
            }
            
            /*
            if(dealRecord.Account.RecordType.Name != CRM_AppConstants.ACCOUNT_RECORDTYPE_SOLD_TO 
             || dealRecord.Account.Planning_Customer__c == false
             || (dealRecord.Account.Status__c!=CRM_AppConstants.ACCOUNT_STATUS_ACTIVE && dealRecord.Account.Status__c!=CRM_AppConstants.ACCOUNT_STATUS_EXPLANNING)
             || (dealRecord.Account.Sales_Organization__c!= CRM_AppConstants.TERRITORY_GERMANY_CODE && dealRecord.Account.Sales_Organization__c!=CRM_AppConstants.TERRITORY_SWITZERLAND_CODE) 
             )
            {
                throw new CRM_GenerateOrderFromDealControllerException(Label.CRM_Restrict_Order_Generation_for_Filter);
            } 
            
            */
              
            // Logic to call the Visualflow
            params.put('var_DealId',opt.ID);
            Flow.Interview.Opportunity_to_Order GenerateOrder = new Flow.Interview.Opportunity_to_Order(params);
            GenerateOrder.Start();
            
            String returnValue = (String)GenerateOrder.getVariableValue('var_NewOrderId');
            
            if(String.isNotBlank(returnValue)){
                orderPage= new PageReference('/'+returnValue+'/e?retURL=%2F'+returnValue);
                orderPage.setRedirect(true);
            }
            return orderPage;
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    
    public class GenerateOrderFromDealControllerException extends Exception {
    }
}